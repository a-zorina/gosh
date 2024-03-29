#!/bin/bash
#	This file is part of Ever OS.
#	
#	Ever OS is free software: you can redistribute it and/or modify 
#	it under the terms of the Apache License 2.0 (http://www.apache.org/licenses/)
#	
#	Copyright 2019-2022 (c) EverX

fn=../gosh
fn_src=$fn.sol
fn_abi=$fn.abi.json
fn_code=$fn.tvc
fn_keys=$fn.keys.json

while getopts "fh" opt; do
  case $opt in
    f)
    if [ -f $fn_keys ]; then rm $fn_keys; fi
    shift
    ;;
    h)
    echo Usage: $0 -f NETWORK
    echo
    echo "  -f (optional) - force to redeploy GOSH"
    echo "  NETWORK (optional) - points to network endpoint:"
    echo "      localhost - Evernode SE (default)"
    echo "      net.ton.dev - devnet"
    echo "      main.ton.dev - mainnet"
    echo
    exit 0
    ;;
  esac
done

export TVM_LINKER=tvm_linker
export TONOS_CLI=tonos-cli
export NETWORK=${1:-localhost}

echo "[deploy $fn]"

./deploy_contract.sh $fn 20000000000 || exit 1
GOSH_ADDR=$(cat $fn.addr)

echo "load \`repo\`-contract"
REPO_CODE=$($TVM_LINKER decode --tvc ../repository.tvc | sed -n '/code:/ s/ code: // p')
REPO_DATA=$($TVM_LINKER decode --tvc ../repository.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setRepository "{\"code\":\"$REPO_CODE\",\"data\":\"$REPO_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

echo "load \`commit\`-contract"
COMMIT_CODE=$($TVM_LINKER decode --tvc ../commit.tvc | sed -n '/code:/ s/ code: // p')
COMMIT_DATA=$($TVM_LINKER decode --tvc ../commit.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setCommit "{\"code\":\"$COMMIT_CODE\",\"data\":\"$COMMIT_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

echo "load \`blob\`-contract"
BLOB_CODE=$($TVM_LINKER decode --tvc ../blob.tvc | sed -n '/code:/ s/ code: // p')
BLOB_DATA=$($TVM_LINKER decode --tvc ../blob.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setBlob "{\"code\":\"$BLOB_CODE\",\"data\":\"$BLOB_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

echo "load \`snapshot\`-contract"
SNAPSHOT_CODE=$($TVM_LINKER decode --tvc ../snapshot.tvc | sed -n '/code:/ s/ code: // p')
SNAPSHOT_DATA=$($TVM_LINKER decode --tvc ../snapshot.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setSnapshot "{\"code\":\"$SNAPSHOT_CODE\",\"data\":\"$SNAPSHOT_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

echo ===================== GOSH =====================
echo addr: $GOSH_ADDR
echo keys: $(cat $fn_keys)
