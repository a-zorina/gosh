#!/usr/bin/env bash

[[ -z "$1" ]] && exit

SCRIPT_DIR=$(dirname "${BASH_SOURCE[-1]}")
cd "$SCRIPT_DIR" || exit
DOCKER_REG="${DOCKER_REG:-257f3948.gra7.container-registry.ovh.net/library}"

case "$1" in
    buildctl)
        set -x
        buildctl --addr=docker-container://buildkitd build \
            --frontend gateway.v0 \
            --local dockerfile=. \
            --local context=. \
            --opt source="$DOCKER_REG"/buildkit-gosh \
            --opt filename=docker-gosh-buildctl.yaml \
            --opt wallet="$WALLET" \
            --opt wallet_secret="$WALLET_SECRET" \
            --opt label:test=1 \
            --opt log=1 \
            --output type=image,name="$DOCKER_REG"/buildctl-gosh-simple,push=true
        ;;
    runctl)
        docker pull "$DOCKER_REG"/buildctl-gosh-simple
        docker run --rm "$DOCKER_REG"/buildctl-gosh-simple cat /message.txt
        ;;
esac
