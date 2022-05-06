#!/bin/bash

sorce ./env.sh
export SERVICE_NAME=kong-pg

mkdir -p ${PG_DATA}
docker pull ${PG_DOCKER_IMAGE}
docker service scale ${SERVICE_NAME}=0
docker service rm ${SERVICE_NAME}
docker service create --replicas 1 \
  --name ${SERVICE_NAME} \
  --mount type=bind,src=${PG_DATA},dst=/var/lib/postgresql/data \
  --publish published=${PG_PORT},target=5432 \
  --env "PGDATA=/var/lib/postgresql/data/pgdata" \
  --env "POSTGRES_USER=kong" \
  --env "POSTGRES_PASSWORD=${PG_PASSWORD}" \
  ${PG_DOCKER_IMAGE}
