#!/bin/bash
set -e

if [ -z $TONOS_CLI ]; then
    TONOS_CLI=tonos-cli
fi

if [ -z $NETWORK ]; then
    NETWORK=localhost
fi

if [ "$NETWORK" == "localhost" ]; then
    WALLET=wallets/localnode/SafeMultisigWallet
else
    WALLET=wallets/devnet/SafeMultisigWallet
fi

GIVER=$(cat $WALLET.addr)
GIVER_ABI=$WALLET.abi.json
GIVER_KEYS=$WALLET.keys.json

CALLED="submitTransaction {\"dest\":\"$1\",\"value\":$2,\"bounce\":false,\"allBalance\":false,\"payload\":\"\"}"
$TONOS_CLI -u $NETWORK call $GIVER $CALLED --abi $GIVER_ABI --sign $GIVER_KEYS > /dev/null
