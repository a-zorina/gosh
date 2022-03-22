#!/bin/sh

IMAGE='gosh-docker-extension:0.0.1'

# docker-compose build
docker extension rm $IMAGE
DOCKER_BUILDKIT=0 docker build -t $IMAGE .
docker extension install $IMAGE
docker extension dev debug $IMAGE
