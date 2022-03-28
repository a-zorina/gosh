#!/bin/bash
#	This file is part of Ever OS.
#	
#	Ever OS is free software: you can redistribute it and/or modify 
#	it under the terms of the Apache License 2.0 (http://www.apache.org/licenses/)
#	
#	Copyright 2019-2022 (c) EverX

if [ -z $2 ]; then
    echo "Usage: $0 REPO_NAME BRANCH <FROM> <NETWORK>"
    exit
fi

TONOS_CLI=tonos-cli
NETWORK=${4:-localhost}

GOSH=../gosh
GOSH_ABI=$GOSH.abi.json
GOSH_KEYS=$GOSH.keys.json
GOSH_ADDR=$(cat $GOSH.addr)

REPO_ABI=../repository.abi.json
REPO_ADDR=$($TONOS_CLI -j -u $NETWORK run $GOSH_ADDR getAddrRepository "{\"name\":\"$1\"}" --abi $GOSH_ABI | sed -n '/value0/ p' | cut -d'"' -f 4)
FROM_BRANCH=${3:-master}

PAYLOAD=$($TONOS_CLI body --abi $REPO_ABI deployBranch "{\"newname\":\"$2\",\"fromname\":\"$FROM_BRANCH\"}" | sed -n '/Message body:/ s/Message body: // p')
ZERO_15_EVERS=150000000
VALUE=$ZERO_15_EVERS

if [ "$NETWORK" == "localhost" ]; then
    WALLET=wallets/localnode/SafeMultisigWallet
    WALLET_ADDR=$(cat $WALLET.addr)
    WALLET_ABI=$WALLET.abi.json
    WALLET_KEYS=$WALLET.keys.json
    CALLED="submitTransaction {\"dest\":\"$REPO_ADDR\",\"value\":$VALUE,\"bounce\":false,\"allBalance\":false,\"payload\":\"$PAYLOAD\"}"
    $TONOS_CLI -u $NETWORK call $WALLET_ADDR $CALLED --abi $WALLET_ABI --sign $WALLET_KEYS > /dev/null || exit 1
else
    echo wtf?
fi

echo =================== BRANCHES ===================
echo gosh: $GOSH_ADDR
echo repo: $1 \(Addr: $REPO_ADDR\)
$TONOS_CLI -j -u $NETWORK run $REPO_ADDR getAllAddress "{}" --abi $REPO_ABI | jq -r '.value0[] | "\(.key) => \(.value)"'
