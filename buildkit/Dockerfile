# syntax=docker/dockerfile:1.3

ARG GOLANG_IMAGE=golang:1.17.8-alpine@sha256:f4ece20984a30d1065b04653bf6781f51ab63421b4b8f011565de0401cfe58d7

FROM ${GOLANG_IMAGE} AS build
WORKDIR /src
ENV CGO_ENABLED=0
RUN --mount=target=. --mount=target=/root/.cache,type=cache --mount=target=/go/pkg,type=cache \
  go build -trimpath -ldflags "-s -w" -o /out/buildkit-gosh .

# FROM scratch
FROM bash
COPY --from=build /out/ /
ENV WEBLOG=1
LABEL moby.buildkit.frontend.network.none="false"
LABEL moby.buildkit.frontend.network.host="true"
ENTRYPOINT ["/buildkit-gosh", "frontend"]
