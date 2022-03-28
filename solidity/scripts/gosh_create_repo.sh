#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: $0 REPO_NAME <NETWORK>"
    exit
fi

GOSH=../gosh
GOSH_ABI=$GOSH.abi.json
GOSH_KEYS=$GOSH.keys.json
GOSH_ADDR=$(cat $GOSH.addr)

export TONOS_CLI=tonos-cli
export NETWORK=${2:-localhost}

PAYLOAD=$($TONOS_CLI body --abi $GOSH_ABI deployRepository "{\"name\":\"$1\"}" | sed -n '/Message body:/ s/Message body: // p')
THREE_EVERS=3000000000
VALUE=$THREE_EVERS

if [ "$NETWORK" == "localhost" ]; then
    WALLET=wallets/localnode/SafeMultisigWallet
else
    WALLET=wallets/devnet/SafeMultisigWallet
fi

WALLET_ADDR=$(cat $WALLET.addr)
WALLET_ABI=$WALLET.abi.json
WALLET_KEYS=$WALLET.keys.json

CALLED="submitTransaction {\"dest\":\"$GOSH_ADDR\",\"value\":$VALUE,\"bounce\":false,\"allBalance\":false,\"payload\":\"$PAYLOAD\"}"
$TONOS_CLI -u $NETWORK call $WALLET_ADDR $CALLED --abi $WALLET_ABI --sign $WALLET_KEYS > /dev/null || exit 1
REPO_ADDR=$($TONOS_CLI -j -u $NETWORK run $GOSH_ADDR getAddrRepository "{\"name\":\"$1\"}" --abi $GOSH_ABI | sed -n '/value0/ p' | cut -d'"' -f 4)

echo ===================== REPO =====================
echo name: $1
echo addr: $REPO_ADDR
