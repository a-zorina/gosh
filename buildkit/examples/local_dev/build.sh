#!/usr/bin/env bash

[[ -z "$1" ]] && exit

SCRIPT_DIR=$(dirname "${BASH_SOURCE[-1]}")
cd "$SCRIPT_DIR" || exit
DOCKER_REG="${DOCKER_REG:-127.0.0.1:5000}"

case "$1" in
    build)
        buildctl --addr=docker-container://buildkitd build \
            --frontend gateway.v0 \
            --local dockerfile=. \
            --local context=. \
            --opt source="$DOCKER_REG"/goshfile \
            --opt filename=goshfile.yaml \
            --opt wallet="$WALLET" \
            --opt wallet_secret="$WALLET_SECRET" \
            --opt wallet_public="$WALLET_PUBLIC" \
            --opt env=env.JAEGER_TRACE=localhost:6831 \
            --output type=image,name="$DOCKER_REG"/buildctl-gosh-simple,push=true
        ;;
    run)
        docker pull "$DOCKER_REG"/buildctl-gosh-simple
        docker run --rm "$DOCKER_REG"/buildctl-gosh-simple cat /message.txt
        ;;
esac
