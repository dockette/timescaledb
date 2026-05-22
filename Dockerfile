ARG TIMESCALEDB_HA_TAG=pg18-ts2.26

FROM timescale/timescaledb-ha:${TIMESCALEDB_HA_TAG}

ARG TIMESCALEDB_HA_TAG

LABEL maintainer="Milan Sulc <sulcmil@gmail.com>"
LABEL org.opencontainers.image.title="TimescaleDB (HA)"
LABEL org.opencontainers.image.description="Thin republish of timescale/timescaledb-ha for Dockette"
LABEL org.opencontainers.image.version="${TIMESCALEDB_HA_TAG}"
LABEL org.opencontainers.image.source="https://github.com/dockette/timescaledb"

COPY docker-entrypoint-initdb.d/020_dockette_extensions.sql /docker-entrypoint-initdb.d/
