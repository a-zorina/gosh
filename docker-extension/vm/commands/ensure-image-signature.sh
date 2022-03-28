#!/bin/sh

IMAGE_HASH=$1
PUBLISHER_KEY=$2

cd /command/content-signature/
node cli check --network net.everos.dev $PUBLISHER_KEY $IMAGE_HASH

