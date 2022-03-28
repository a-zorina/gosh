#!/bin/bash
#	This file is part of Ever OS.
#	
#	Ever OS is free software: you can redistribute it and/or modify 
#	it under the terms of the Apache License 2.0 (http://www.apache.org/licenses/)
#	
#	Copyright 2019-2022 (c) EverX

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
