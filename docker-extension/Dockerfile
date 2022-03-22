FROM alpine:3.3

LABEL org.opencontainers.image.title="GoshDockerExtension" \
    org.opencontainers.image.description="Gosh Docker Extension description stub." \
    org.opencontainers.image.vendor="Tonlabs" \
    com.docker.desktop.extension.api.version="1.0.0-beta.1"

RUN apk --no-cache add curl

COPY ./ui /ui
COPY metadata.json /
COPY ./vm/docker-compose.yaml /
COPY ./vm/docker-ps.sh /command/docker-ps.sh

CMD [ "sleep", "infinity" ]
