#!/bin/bash

fn=../gosh
fn_src=$fn.sol
fn_abi=$fn.abi.json
fn_code=$fn.tvc
fn_keys=$fn.keys.json

export TVM_LINKER=tvm_linker
export TONOS_CLI=tonos-cli
export NETWORK=${1:-localhost}

echo "[deploy $fn]"

./deploy_contract.sh $fn 100000000000 || exit 1
GOSH_ADDR=$(cat $fn.addr)

REPO_CODE=$($TVM_LINKER decode --tvc ../repository.tvc | sed -n '/code:/ s/ code: // p')
REPO_DATA=$($TVM_LINKER decode --tvc ../repository.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setRepository "{\"code\":\"$REPO_CODE\",\"data\":\"$REPO_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

COMMIT_CODE=$($TVM_LINKER decode --tvc ../commit.tvc | sed -n '/code:/ s/ code: // p')
COMMIT_DATA=$($TVM_LINKER decode --tvc ../commit.tvc | sed -n '/data:/ s/ data: // p')
$TONOS_CLI -u $NETWORK call $GOSH_ADDR setCommit "{\"code\":\"$COMMIT_CODE\",\"data\":\"$COMMIT_DATA\"}" --abi $fn_abi --sign $fn_keys > /dev/null || exit 1

#$TONOS_CLI -u $NETWORK call $GOSH_ADDR setBlob {}

echo ===================== GOSH =====================
echo addr: $GOSH_ADDR
echo keys: $(cat $fn_keys)