FROM node:16.14-alpine
# FROM alpine:3.3

LABEL org.opencontainers.image.title="GoshDockerExtension" \
    org.opencontainers.image.description="Gosh Docker Extension description stub." \
    org.opencontainers.image.vendor="Tonlabs" \
    com.docker.desktop.extension.api.version="1.0.0-beta.1"

RUN apk --no-cache add curl coreutils docker
RUN apk add --no-cache ca-certificates file iptables libc6-compat libgcc libstdc++ wget && \
    update-ca-certificates && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

# COPY --from=node /usr/lib /usr/lib
# COPY --from=node /usr/local/share /usr/local/share
# COPY --from=node /usr/local/lib /usr/local/lib
# COPY --from=node /usr/local/include /usr/local/include
# COPY --from=node /usr/local/bin /usr/local/bin

COPY ./ui /ui
COPY metadata.json /
COPY ./vm/docker-compose.yaml /
COPY ./vm/commands/ /command/
COPY ./tmp/ /command/

RUN cd /command/content-signature/ && npm install && npm -g install typescript && tsc

CMD [ "sleep", "infinity" ]
