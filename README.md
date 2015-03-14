# docker-couchdb

## Installation

```sh
docker pull rocoto/couchdb
```

## Usage

```sh
docker run -it -p 5984:5984 -v /path/on/host:/data rocoto/couchdb
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
