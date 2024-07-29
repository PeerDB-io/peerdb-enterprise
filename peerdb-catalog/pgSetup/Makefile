GOFILE=main.go
BINARY=peerdb-pg-setup

GO=go
CGO_ENABLED=0

all: build

build:
	$(GO) build -ldflags "-s -w" -o $(BINARY) $(GOFILE)

clean:
	rm -f $(BINARY)

.PHONY: all build clean
