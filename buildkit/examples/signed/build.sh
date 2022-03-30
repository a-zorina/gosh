#!/usr/bin/env bash

if [[ -z "$WALLET_PUBLIC" ]] || [[ -z "$WALLET_SECRET" ]] ; then
    echo "Make sure \$WALLET \$WALLET_PUBLIC \$WALLET_SECRET are set"
    exit
fi

TARGET_IMAGE=teamgosh/sample-target-image

echo Run buildkitd containered
docker rm -f buildkitd || true
docker run -d --name buildkitd --network host --privileged moby/buildkit:latest

echo Build $TARGET_IMAGE
buildctl --addr=docker-container://buildkitd build \
    --frontend gateway.v0 \
    --local dockerfile=. \
    --local context=. \
    --opt source=teamgosh/goshfile \
    --opt filename=goshfile.yaml \
    --opt wallet_public="$WALLET_PUBLIC" \
    --output type=image,name="$TARGET_IMAGE",push=true

echo Push $TARGET_IMAGE
docker push $TARGET_IMAGE

echo Sign image
