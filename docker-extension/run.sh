#!/bin/sh

IMAGE='gosh-docker-extension:0.0.1'

# 1st step - remove old! So there's no confusion later
docker extension rm $IMAGE
#---
set -e

rm -rf ./tmp
mkdir -p ./tmp
cp -r ../content-signature ./tmp/
# docker-compose build
DOCKER_BUILDKIT=0 docker build -t $IMAGE .
docker extension install $IMAGE
docker extension dev debug $IMAGE

rm -rf ./tmp
