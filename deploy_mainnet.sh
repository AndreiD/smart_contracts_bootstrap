#!/bin/bash

source .env
echo "🔨 Deploying on base mainnet"


forge script ./script/SpinLouder.s.sol -f $MAINNET_RPC --chain-id 8453 --broadcast --verify -vvvv --private-key $PRIVATE_KEY