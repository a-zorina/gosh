#!/bin/bash
set -e

if [ -z $TONOS_CLI ]; then
    TONOS_CLI=tonos-cli
fi
if [ -z $NETWORK ]; then
    NETWORK=localhost
fi
if [ -e $1.keys.json ]; then
    KEYOPT=setkey
fi
BALANCE=${2:-2000000000}

echo "[$0] genaddr..."
CONTRACT_ADDRESS=$($TONOS_CLI genaddr $1.tvc $1.abi.json --${KEYOPT:-genkey} $1.keys.json | grep "Raw address:" | cut -d ' ' -f 3)
echo ADDR=$CONTRACT_ADDRESS

echo "[$0] request giver..."
./giver.sh $CONTRACT_ADDRESS $BALANCE

echo "[$0] deploy $1"
$TONOS_CLI --url $NETWORK deploy $1.tvc "{}" --sign $1.keys.json --abi $1.abi.json > /dev/null

echo -n $CONTRACT_ADDRESS > $1.addr
