#!/bin/bash
sorce ./env.sh

docker pull ${KONG_DOCKER_IMAGE}
docker run --rm \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=${PG_IP}" \
     -e "KONG_PG_PORT=${PG_PORT}" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=${PG_PASSWORD}" \
     ${KONG_DOCKER_IMAGE} kong migrations bootstrap
