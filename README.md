<h1 align=center>Dockette / TimescaleDB</h1>

<p align=center>
   Minimal Docker image wrapping <a href="https://github.com/timescale/timescaledb-docker-ha">TimescaleDB HA</a> (<code>timescale/timescaledb-ha</code>) under <code>dockette/timescaledb</code> on Docker Hub. Tags use the <code>ha-</code> prefix for the HA image line (e.g. <code>ha-pg18-ts2.26</code> → upstream <code>timescale/timescaledb-ha:pg18-ts2.26</code>).
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

## What it is

[TimescaleDB](https://github.com/timescale/timescaledb) on PostgreSQL with the HA distribution image. Upstream docs: [timescaledb-docker-ha](https://github.com/timescale/timescaledb-docker-ha).

This build adds SQL under `/docker-entrypoint-initdb.d/` so common monitoring/contrib extensions are created on **first initialization** (empty data directory). Entries such as `auto_explain` are loaded via `shared_preload_libraries` only and are **not** separate extensions here.

## Usage

Example matching the [upstream HA image layout](https://github.com/timescale/timescaledb-docker-ha/blob/master/Dockerfile): default **`PGDATA`** is often `/home/postgres/pgdata/data`. Set **`PGDATA`** (and your volume mount) to match your deployment.

```sh
docker run --name some-timescaledb -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -v tsdb-data:/home/postgres/pgdata \
  dockette/timescaledb:ha-pg18-ts2.26
```

Listen port is **5432**. For a custom data path (e.g. Nomad mounting `/pgdata`), set **`PGDATA`** accordingly (for example `/pgdata/data` if that is where PostgreSQL should store cluster files).

### Nomad and `/docker-entrypoint-initdb.d`

If you bind-mount a host or alloc directory **onto** `/docker-entrypoint-initdb.d`, you **replace** the entire directory inside the container. Scripts shipped in this image (and upstream’s own init scripts) will **not** be visible unless your mount includes those files.

1. Prefer dropping that mount and rely on the image’s `/docker-entrypoint-initdb.d/`.
2. If you keep templated SQL in `local/init/`, you must ship **every** required init file there (higher maintenance).
3. Init SQL runs only when **`PGDATA`** is empty; existing clusters need manual `CREATE EXTENSION` or a migration job.

### Optional deeper smoke test

After `make build`, you can run a one-off container with a fresh volume, `POSTGRES_PASSWORD`, wait for `pg_isready`, then `psql -c '\dx'` to confirm extensions (slower than `make test`).

## Versions

| Image tag | Equivalent upstream |
|-----------|---------------------|
| `dockette/timescaledb:ha-pg18-ts2.26` | `timescale/timescaledb-ha:pg18-ts2.26` |
| `dockette/timescaledb:latest` | same as current CI pin (rolling) |

This image is a **thin republish**: `FROM timescale/timescaledb-ha:${TIMESCALEDB_HA_TAG}` plus bundled init SQL.

-----

Consider supporting [f3l1x on GitHub Sponsors](https://github.com/sponsors/f3l1x) if you rely on this. Thanks for using it.
