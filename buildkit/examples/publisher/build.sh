#!/usr/bin/env bash
set -e

TARGET_IMAGE=teamgosh/sample-target-image
NETWORKS="${NETWORKS:-https://gra01.net.everos.dev,https://rbx01.net.everos.dev,https://eri01.net.everos.dev}"

if [[ -z "$WALLET" ]] || [[ -z "$WALLET_PUBLIC" ]] || [[ -z "$WALLET_SECRET" ]] ; then
    echo "Make sure \$WALLET \$WALLET_PUBLIC \$WALLET_SECRET are set"
    echo "export WALLET=..."
    echo "export WALLET_SECRET=..."
    echo "export WALLET_PUBLIC=..."
    exit
fi

echo ===================================
echo Run buildkitd containered
echo ===================================

docker rm -f buildkitd || true
docker run -d --name buildkitd --network host --privileged moby/buildkit:latest

echo ===================================
echo Build $TARGET_IMAGE
echo ===================================

buildctl --addr=docker-container://buildkitd build \
    --frontend gateway.v0 \
    --local dockerfile=. \
    --local context=. \
    --opt source=teamgosh/goshfile \
    --opt filename=goshfile.yaml \
    --opt wallet_public="$WALLET_PUBLIC" \
    --output type=image,name="$TARGET_IMAGE",push=true

echo ===================================
echo Pull $TARGET_IMAGE after buildctl
echo ===================================

docker pull $TARGET_IMAGE

TARGET_IMAGE_SHA=$(docker inspect --format='{{index (split (index .RepoDigests 0) "@") 1}}' $TARGET_IMAGE)
echo TARGET_IMAGE_SHA=\'"$TARGET_IMAGE_SHA"\'

if [[ -z "$TARGET_IMAGE_SHA" ]] ; then
    echo Target image hash not found
    exit
fi

echo ===================================
echo Sign image
echo ===================================

docker run --rm teamgosh/sign-cli sign \
    -n "$NETWORKS" \
    -g "$WALLET" \
    -s "$WALLET_SECRET" \
    "$WALLET_SECRET" \
    "$TARGET_IMAGE_SHA"
