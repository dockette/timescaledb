<h1 align=center>Dockette / TimescaleDB</h1>

<p align=center>
   🎁 TimescaleDB HA image with common extensions created on first start.
</p>

<p align=center>
🕹 <a href="https://f3l1x.io">f3l1x.io</a> | 💻 <a href="https://github.com/f3l1x">f3l1x</a> | 🐦 <a href="https://twitter.com/xf3l1x">@xf3l1x</a>
</p>

<p align=center>
  <a href="https://hub.docker.com/r/dockette/timescaledb/"><img src="https://badgen.net/docker/pulls/dockette/timescaledb"></a>
  <a href="https://bit.ly/ctteg"><img src="https://badgen.net/badge/support/gitter/cyan"></a>
  <a href="https://github.com/sponsors/f3l1x"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
</p>

-----

[TimescaleDB](https://github.com/timescale/timescaledb) on PostgreSQL, built on the
[timescaledb-ha](https://github.com/timescale/timescaledb-docker-ha) image (`timescale/timescaledb-ha`) and published
as `dockette/timescaledb`. It adds SQL that creates common monitoring and contrib extensions.

## Features

- TimescaleDB HA `pg18-ts2.30`: `FROM timescale/timescaledb-ha:pg18-ts2.30`, nothing else changed
- Extensions are created on **first initialization** (empty data directory) by SQL in `/docker-entrypoint-initdb.d/`
- Entries such as `auto_explain` are loaded through `shared_preload_libraries` only and are **not** separate extensions
  here
- Listen port is `5432`

## Usage

```sh
docker run --name some-timescaledb -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -v tsdb-data:/home/postgres/pgdata \
  dockette/timescaledb:ha-pg18-ts2.30
```

## Configuration

The upstream [HA image](https://github.com/timescale/timescaledb-docker-ha/blob/master/Dockerfile) uses
`/home/postgres/pgdata/data` as the default `PGDATA`. Set `PGDATA` and your volume mount to match your deployment. For
a custom path (for example Nomad mounting `/pgdata`), use `PGDATA=/pgdata/data` if that is where PostgreSQL should store
the cluster files.

Init SQL runs only when `PGDATA` is empty. Existing clusters need a manual `CREATE EXTENSION` or a migration job.

### Nomad and `/docker-entrypoint-initdb.d`

A bind mount **onto** `/docker-entrypoint-initdb.d` replaces the whole directory in the container. The scripts of this
image and the init scripts of upstream are not visible unless your mount includes those files.

1. Prefer to drop that mount and use the `/docker-entrypoint-initdb.d/` of the image.
2. If you keep templated SQL in `local/init/`, ship **every** required init file there (more maintenance).

## Versions

| Version | Release |
|---------|---------|
| `dockette/timescaledb:ha-pg18-ts2.30-YYYY.MM.DD` | TimescaleDB HA `pg18-ts2.30` in release `YYYY.MM.DD`; pin this one |
| `dockette/timescaledb:ha-pg18-ts2.30` | latest release |
| `dockette/timescaledb:YYYY.MM.DD` | release `YYYY.MM.DD` |
| `dockette/timescaledb:latest` | latest build of `master` |

All versions build on `timescale/timescaledb-ha:pg18-ts2.30`. A TimescaleDB upgrade is a release too. Releases are
listed on [GitHub](https://github.com/dockette/timescaledb/releases).

## Development

```sh
make build          # build the image
make test           # check postgres and the init SQL in the image
make version        # print VERSION
make release        # set today's date in VERSION
```

After `make build`, a deeper check is to start a container with a fresh volume and `POSTGRES_PASSWORD`, wait for
`pg_isready` and run `psql -c '\dx'` to list the extensions. It is slower than `make test`.

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to
[support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
