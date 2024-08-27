#!/bin/bash

source .env
# BNB TESTNET CHAINID 97
# ETH SEPOLIA CHAINID 11155111
echo "deploying on sepolia testnet. chainID 11155111"


forge script ./script/SimpleERC1155Script.s.sol --rpc-url $SEPOLIA_RPC --chain-id 11155111 --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify -vvvv --private-key $PRIVATE_KEY --delay 10 --retries 6