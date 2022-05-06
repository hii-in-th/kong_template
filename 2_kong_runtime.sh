#!/bin/bash
# 'printf "GET / HTTP/1.0\n\n" | nc localhost 8001'
sorce ./env.sh

export SERVICE_NAME=kong-api

docker pull ${KONG_DOCKER_IMAGE}
docker service scale ${SERVICE_NAME}=0
docker service rm ${SERVICE_NAME}
docker service create --replicas 1 \
  --name ${SERVICE_NAME} \
  --publish published=${KONG_8000},target=8000 \
  --publish published=${KONG_8443},target=8443 \
  --publish published=${KONG_8001},target=8001 \
  --publish published=${KONG_8444},target=8444 \
  --env "KONG_DATABASE=postgres" \
  --env "KONG_PG_HOST=${PG_IP}" \
  --env "KONG_PG_PORT=${PG_PORT}" \
  --env "KONG_PG_USER=kong" \
  --env "KONG_PG_PASSWORD=${PG_PASSWORD}" \
  --env "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  --env "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  --env "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  --env "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  --env "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
  --health-cmd='ls' \
  --health-timeout=5s \
  --health-retries=6 \
  --health-interval=15s \
  --health-start-period=20s \
  ${KONG_DOCKER_IMAGE}
