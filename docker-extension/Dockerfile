FROM alpine:3.3

LABEL org.opencontainers.image.title="GoshDockerExtension" \
    org.opencontainers.image.description="Gosh Docker Extension description stub." \
    org.opencontainers.image.vendor="Tonlabs" \
    com.docker.desktop.extension.api.version="1.0.0-beta.1"

RUN apk --no-cache add curl coreutils docker

COPY ./ui /ui
COPY metadata.json /
COPY ./vm/docker-compose.yaml /
COPY ./vm/commands/ /command/

CMD [ "sleep", "infinity" ]
