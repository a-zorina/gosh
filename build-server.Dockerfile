FROM alpine:3.15.0
ENV CI_CONTAINER=alpine
ENV DEVELOPER=1
ENV CC=gcc
ENV MAKEFLAGS="$MAKEFLAGS PYTHON_PATH=/usr/bin/python3 USE_LIBPCRE2=Yes NO_REGEX=Yes ICONV_OMITS_BOM=Yes GIT_TEST_UTF8_LOCALE=C.UTF-8 CC=gcc"
ENV jobname="linux-musl"
ENV container_cache_dir=/tmp/container-cache

COPY ci/install-docker-dependencies.sh install-docker-dependencies.sh
RUN ./install-docker-dependencies.sh 
EXPOSE 22
RUN apk add openssh-server \
    && apk add openssh
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/git-client -s /bin/sh -D git-client
RUN echo -n 'git-client:foo' | chpasswd


