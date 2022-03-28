#!/bin/sh

IMAGE='gosh-docker-extension:0.0.1'

mkdir ./tmp
cp -r ../content-signature ./tmp/
# docker-compose build
docker extension rm $IMAGE
DOCKER_BUILDKIT=0 docker build -t $IMAGE .
docker extension install $IMAGE
docker extension dev debug $IMAGE

rm -rf ./tmp
