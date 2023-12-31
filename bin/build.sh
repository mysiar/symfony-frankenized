#!/bin/bash

source .env

rm -f ${APP_STATIC_NAME}
docker build -t ${APP_STATIC_NAME} -f Dockerfile.static-build .
docker cp $(docker create --name ${APP_STATIC_NAME}-tmp ${APP_STATIC_NAME}):/go/src/app/dist/frankenphp-linux-x86_64 ./build/${APP_STATIC_NAME}
docker rm ${APP_STATIC_NAME}-tmp
chmod +x ./build/${APP_STATIC_NAME}
docker image rm ${APP_STATIC_NAME}
