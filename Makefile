DOCKER_IMAGE=dockette/timescaledb
TIMESCALEDB_HA_TAG?=pg18-ts2.26
DOCKER_TAG?=ha-$(TIMESCALEDB_HA_TAG)
DOCKER_PLATFORMS?=linux/amd64

.PHONY: build
build:
	docker buildx build --platform ${DOCKER_PLATFORMS} \
		--build-arg TIMESCALEDB_HA_TAG=${TIMESCALEDB_HA_TAG} \
		-t ${DOCKER_IMAGE}:${DOCKER_TAG} \
		.

.PHONY: test
test:
	docker run --rm --platform ${DOCKER_PLATFORMS} ${DOCKER_IMAGE}:${DOCKER_TAG} postgres --version
	docker run --rm --platform ${DOCKER_PLATFORMS} --entrypoint ls ${DOCKER_IMAGE}:${DOCKER_TAG} /docker-entrypoint-initdb.d/020_dockette_extensions.sql
