#!/bin/sh

curl --unix-socket /var/run/docker.sock "http://localhost/v1.41/containers/json"
