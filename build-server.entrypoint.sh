#!/bin/sh

/usr/src/git/ci/run-docker-build.sh

ssh-keygen -A
/usr/sbin/sshd -D -e
