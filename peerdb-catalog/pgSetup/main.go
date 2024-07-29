package main

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"os"

	"github.com/AlecAivazis/survey/v2"
	"github.com/jackc/pgx/v5"
	"github.com/sirupsen/logrus"
)

type Config struct {
	Host                  string
	Port                  string
	User                  string
	Password              string
	Database              string
	TemporalDeployEnabled bool
	TemporalUser          string
	TemporalPassword      string
	TemporalDB            string
	TemporalVisibilityDB  string
	PeerDBCatalogDB       string
	AssumeYes             bool
}

func (cfg *Config) Validate() error {
	if cfg.Host == "" {
		return errors.New("missing PG_HOST")
	}
	if cfg.Port == "" {
		return errors.New("missing PG_PORT")
	}
	if cfg.User == "" {
		return errors.New("missing PG_USER")
	}
	if cfg.Password == "" {
		return errors.New("missing PG_PASSWORD")
	}
	if cfg.Database == "" {
		return errors.New("missing PG_DATABASE")
	}
	if cfg.TemporalUser == "" {
		return errors.New("missing TEMPORAL_USER")
	}
	if cfg.TemporalPassword == "" {
		return errors.New("missing TEMPORAL_PASSWORD")
	}
	if cfg.TemporalDB == "" {
		return errors.New("missing TEMPORAL_DB")
	}
	if cfg.TemporalVisibilityDB == "" {
		return errors.New("missing TEMPORAL_VISIBILITY_DB")
	}
	if cfg.PeerDBCatalogDB == "" {
		return errors.New("missing PEER_DB_CATALOG_DB")
	}
	return nil
}

func (cfg *Config) GetDSN(dbname string) string {
	// encode the password to avoid special characters issues
	encodedPassword := url.QueryEscape(cfg.Password)
	return fmt.Sprintf("postgres://%s:%s@%s:%s/%s", cfg.User, encodedPassword, cfg.Host, cfg.Port, dbname)
}

func connectToPostgres(ctx context.Context, cfg *Config) (*pgx.Conn, error) {
	conn, err := pgx.Connect(ctx, cfg.GetDSN(cfg.Database))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to PostgreSQL: %w", err)
	}
	return conn, nil
}

func connectToPostgresWithDB(ctx context.Context, cfg *Config, dbname string) (*pgx.Conn, error) {
	conn, err := pgx.Connect(ctx, cfg.GetDSN(dbname))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to PostgreSQL: %w", err)
	}
	return conn, nil
}

func executeQuery(conn *pgx.Conn, query string) error {
	_, err := conn.Exec(context.Background(), query)
	if err != nil {
		return fmt.Errorf("failed to execute query: %w", err)
	}
	return nil
}

var log = logrus.New()

func checkAndCreateUser(conn *pgx.Conn, ctx context.Context, cfg *Config) error {
	var roleName string
	err := conn.QueryRow(ctx, "SELECT rolname FROM pg_roles WHERE rolname=$1", cfg.TemporalUser).Scan(&roleName)

	switch {
	case errors.Is(err, pgx.ErrNoRows):
		prompt := survey.Confirm{
			Message: fmt.Sprintf("User %s does not exist. Do you want to create it?", cfg.TemporalUser),
			Default: cfg.AssumeYes,
		}
		confirm := false
		if cfg.AssumeYes {
			confirm = true
		} else {
			err := survey.AskOne(&prompt, &confirm)
			if err != nil || !confirm {
				return errors.New("operation aborted")
			}
		}
		log.Infof("Creating user %s...", cfg.TemporalUser)
		err = executeQuery(conn, fmt.Sprintf("CREATE USER %s WITH PASSWORD '%s';", cfg.TemporalUser, cfg.TemporalPassword))
		if err != nil {
			return err
		}
	case err != nil:
		return err
	default:
		log.Infof("User %s already exists", roleName)
	}

	return nil
}

func checkAndCreateDB(cfg *Config, conn *pgx.Conn, ctx context.Context, dbName, user string) error {
	var name string
	err := conn.QueryRow(ctx, "SELECT datname FROM pg_database WHERE datname=$1", dbName).Scan(&name)

	switch {
	case errors.Is(err, pgx.ErrNoRows):
		prompt := survey.Confirm{
			Message: fmt.Sprintf("Database %s does not exist. Do you want to create it?", dbName),
			Default: cfg.AssumeYes,
		}
		confirm := false
		if cfg.AssumeYes {
			confirm = true
		} else {
			err := survey.AskOne(&prompt, &confirm)
			if err != nil || !confirm {
				return errors.New("operation aborted")
			}
		}
		log.Infof("Creating database %s...", dbName)
		err = executeQuery(conn, fmt.Sprintf("CREATE DATABASE %s;", dbName))
		if err != nil {
			return err
		}

		log.Infof("Granting privileges on database %s to user %s...", dbName, user)
		err = executeQuery(conn, fmt.Sprintf("GRANT ALL PRIVILEGES ON DATABASE %s to %s;", dbName, user))
		if err != nil {
			return err
		}

		dbConn, err := connectToPostgresWithDB(ctx, cfg, dbName)
		if err != nil {
			return err
		}
		defer dbConn.Close(ctx)

		err = executeQuery(dbConn, fmt.Sprintf("GRANT ALL PRIVILEGES ON SCHEMA public TO %s;", user))
		if err != nil {
			return err
		}
	case err != nil:
		return err
	default:
		log.Infof("Database %s already exists", name)
	}

	return nil
}

func createUserAndDatabases(cfg *Config) error {
	ctx := context.Background()
	conn, err := connectToPostgres(ctx, cfg)
	if err != nil {
		return err
	}
	defer conn.Close(ctx)

	log.Infof("Connected to PostgreSQL at %s:%s", cfg.Host, cfg.Port)
	if cfg.TemporalDeployEnabled {
		err = checkAndCreateUser(conn, ctx, cfg)
		if err != nil {
			return err
		}
	}

	if cfg.TemporalDeployEnabled {
		temporalDBs := []string{cfg.TemporalDB, cfg.TemporalVisibilityDB}
		for _, db := range temporalDBs {
			err = checkAndCreateDB(cfg, conn, ctx, db, cfg.TemporalUser)
			if err != nil {
				log.Errorf("Failed to create database %s: %v", db, err)
				return err
			}
		}
	}

	err = checkAndCreateDB(cfg, conn, ctx, cfg.PeerDBCatalogDB, cfg.User)
	if err != nil {
		log.Errorf("Failed to create database %s: %v", cfg.PeerDBCatalogDB, err)
		return err
	}

	log.Infof("All done!")
	return nil
}

func main() {
	log.SetFormatter(&logrus.TextFormatter{
		FullTimestamp: true,
	})
	log.SetLevel(logrus.InfoLevel)

	cfg := &Config{
		Host:                  os.Getenv("PG_HOST"),
		Port:                  os.Getenv("PG_PORT"),
		User:                  os.Getenv("PG_USER"),
		Password:              os.Getenv("PG_PASSWORD"),
		Database:              os.Getenv("PG_DATABASE"),
		TemporalDeployEnabled: os.Getenv("TEMPORAL_DEPLOY_ENABLED") == "true",
		TemporalUser:          os.Getenv("TEMPORAL_USER"),
		TemporalPassword:      os.Getenv("TEMPORAL_PASSWORD"),
		TemporalDB:            os.Getenv("TEMPORAL_DB"),
		TemporalVisibilityDB:  os.Getenv("TEMPORAL_VISIBILITY_DB"),
		PeerDBCatalogDB:       os.Getenv("PEERDB_CATALOG_DATABASE"),
		AssumeYes:             os.Getenv("ASSUME_YES") == "true",
	}

	err := cfg.Validate()
	if err != nil {
		log.Fatalf("Invalid configuration: %v", err)
	}

	err = createUserAndDatabases(cfg)
	if err != nil {
		log.Fatalf("Failed to create user and databases: %v", err)
	}
}
