Checklist:

* [ ] Bumped the chart version(s) according to semantic versioning
  * [ ] Bump up both `peerdb` and `peerdb-catalog` charts to the same version 
* [ ] Update `peerdb-catalog/values.yaml`:
  * [ ] Set `temporal.admintools.image.tag` pointing to version with correct value from the dependency in `peerdb/Chart.yaml` subdependency
