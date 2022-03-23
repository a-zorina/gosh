#!/bin/bash
set -e

GIVER=0:d5f5cfc4b52d2eb1bd9d3a8e51707872c7ce0c174facddd0e06ae5ffd17d2fcd
GIVER_KEYS=$(cat <<EOF
{"public": "99c84f920c299b5d80e4fcce2d2054b05466ec9df19532a688c10eb6dd8d6b33","secret": "73b60dc6a5b1d30a56a81ea85e0e453f6957dbfbeefb57325ca9f7be96d3fe1a"}
EOF
)
GIVER_ABI=$(cat <<EOF
{
	"ABI version": 2,
	"header": ["pubkey", "time", "expire"],
	"functions": [{
		"name": "sendTransaction",
		"inputs": [
			{"name":"dest","type":"address"},
			{"name":"value","type":"uint128"},
			{"name":"bounce","type":"bool"},
			{"name":"flags","type":"uint8"},
			{"name":"payload","type":"cell"}
		],
		"outputs": []
    }, {
		"name": "submitTransaction",
		"inputs": [
			{"name":"dest","type":"address"},
			{"name":"value","type":"uint128"},
			{"name":"bounce","type":"bool"},
			{"name":"allBalance","type":"bool"},
			{"name":"payload","type":"cell"}
		],
		"outputs": [
			{"name":"transId","type":"uint64"}
		]
	}]
}
EOF
)

DEVNET_GIVER_ADDR=0:2bb4a0e8391e7ea8877f4825064924bd41ce110fce97e939d3323999e1efbb13
DEVNET_GIVER_KEYS=$(cat <<EOF
{"secret": "6e9ca582df77a86da93c0668d7f6fbb010459156b434d3059005ef396c825f59","public": "95c06aa743d1f9000dd64b75498f106af4b7e7444234d7de67ea26988f6181df"}
EOF
)
DEVNET_GIVER_ABI=$(cat <<EOF
{
	"ABI version": 2,
	"header": ["time", "expire"],
	"functions": [{
		"name": "sendTransaction",
		"inputs": [
			{"name":"dest","type":"address"},
			{"name":"value","type":"uint128"},
			{"name":"bounce","type":"bool"}
		],
		"outputs": []
	}]
}
EOF
)

if [ -z $TONOS_CLI ]; then
    TONOS_CLI=tonos-cli
fi

if [ -z $NETWORK ]; then
    NETWORK=localhost
fi

case "$NETWORK" in
    net.ton.dev*)
    GIVER=$(cat giver_devnet.addr)
    GIVER_KEYS=giver_devnet.keys.json
    GIVER_ABI=giver_devnet.abi.json
    CALLED="sendTransaction {\"dest\":\"$1\",\"value\":$2,\"bounce\":false}"
    ;;
    *)
    GIVER=$(cat giver_localnode.addr)
    GIVER_KEYS=giver_localnode.keys.json
    GIVER_ABI=giver_localnode.abi.json
    CALLED="submitTransaction {\"dest\":\"$1\",\"value\":$2,\"bounce\":false,\"allBalance\":false,\"payload\":\"\"}"
    ;;
esac

$TONOS_CLI -u $NETWORK call $GIVER $CALLED --abi $GIVER_ABI --sign $GIVER_KEYS > /dev/null
