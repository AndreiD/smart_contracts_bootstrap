// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SimpleERC1155} from "../src/SimpleERC1155.sol";

contract SimpleERC1155Script is Script {
    SimpleERC1155 public tContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        tContract = new SimpleERC1155(0x123456989eF98b3071e65963e6228cbDd32da382, "https://base.uri");

        vm.stopBroadcast();
    }
}
