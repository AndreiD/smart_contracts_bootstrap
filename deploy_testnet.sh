#!/bin/bash

source .env
echo "deploying on bnb testnet. chainID 97"


forge script ./script/Counter.s.sol --rpc-url $BNB_TESTNET_RPC --chain-id 97 --etherscan-api-key $BASESCAN_API_KEY --broadcast --slow --verify -vvvv --private-key $PRIVATE_KEY --delay 7 --retries 6