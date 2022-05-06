#!/bin/bash

sorce ./env.sh

export SERVICE_NAME=kong-konga

docker pull ${KONGA_DOCKER_IMAGE}
docker service scale ${SERVICE_NAME}=0
docker service rm ${SERVICE_NAME}
docker service create --replicas 1 \
  --name ${SERVICE_NAME} \
  --publish published=${KONGA_PORT},target=1337 \
  --env "TOKEN_SECRET=${KONGA_TOKEN_SECRET}" \
  --env "DB_ADAPTER=postgres" \
  --env "DB_HOST=${PG_IP}" \
  --env "DB_PORT=${PG_PORT}" \
  --env "DB_USER=kong" \
  --env "DB_PASSWORD=${PG_PASSWORD}" \
  --env "DB_DATABASE=konga_db" \
  --env "NODE_ENV=production" \
  ${KONGA_DOCKER_IMAGE}
