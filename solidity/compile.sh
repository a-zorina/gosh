#!/bin/bash

for src in *.sol; do
    if [ $src = "Upgradable.sol" ]; then
        continue
    fi
    echo compile $src
	everdev sol compile $src
	if [ $? -ne 0 ]; then
		exit 1
	fi
done
