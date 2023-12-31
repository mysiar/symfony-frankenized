#!/bin/bash

source .env

docker build -t ${APP_STATIC_IMAGE} -f Dockerfile.app .
