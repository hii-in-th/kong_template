#!/bin/bash

sorce ./env.sh

docker pull ${KONGA_DOCKER_IMAGE}
docker run --rm ${KONGA_DOCKER_IMAGE} -c prepare -a postgres -u postgresql://kong:${PG_PASSWORD}@${PG_IP}:${PG_PORT}/konga_db