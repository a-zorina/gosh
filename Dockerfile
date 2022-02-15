FROM alpine:3.15.0
ENV CI_CONTAINER=alpine
ENV DEVELOPER=1
ENV CC=gcc
ENV MAKEFLAGS="$MAKEFLAGS PYTHON_PATH=/usr/bin/python3 USE_LIBPCRE2=Yes NO_REGEX=Yes ICONV_OMITS_BOM=Yes GIT_TEST_UTF8_LOCALE=C.UTF-8 CC=gcc"
ENV jobname="linux-musl"

COPY . /usr/src/git
RUN /usr/src/git/ci/run-docker-build.sh




