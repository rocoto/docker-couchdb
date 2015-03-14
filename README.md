# docker-couchdb

Yet another `CouchDB` container.

* Built on `Debian`.
* Currently 346.8 Mb image.
* Runs as `couchdb` user.
* Puts all data (databases, views, config files) in a single data volume.

## Installation

```sh
docker pull rocoto/couchdb
```

## Usage

```sh
# Create data container to hold the data.
docker create -v /path/on/host:/data --name couch-data rocoto/couchdb
# Run database server using volumes from data container.
docker run -it -p 5984:5984 --volumes-from couch-data rocoto/couchdb
```

## File structure in data volume

```
./
├── couch.uri
├── dbs
│   ├── _replicator.couch
│   └── _users.couch
├── etc
│   ├── default.ini
│   └── local.ini
├── log
│   └── couch.log
└── views
```
