#!/bin/sh

docker build --tag "build-server" --file build-server.Dockerfile .


cache_dir="${PWD}/cache"
container_cache_dir=/tmp/container-cache

rm t/.prove

docker run \
	--publish 127.0.0.1:5022:22 \
	--volume "${PWD}:/usr/src/git" \
	--volume "$cache_dir:$container_cache_dir" \
	--env cache_dir=$container_cache_dir \
	--env CI_CONTAINER=alpine \
	--env DEVELOPER=1 \
	--env CC=gcc \
	--env MAKEFLAGS="$MAKEFLAGS PYTHON_PATH=/usr/bin/python3 USE_LIBPCRE2=Yes NO_REGEX=Yes ICONV_OMITS_BOM=Yes GIT_TEST_UTF8_LOCALE=C.UTF-8 CC=gcc" \
	--env jobname="linux-musl" \
	-it \
	build-server \
	/usr/src/git/build-server.entrypoint.sh
