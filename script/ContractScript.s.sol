// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MemeCoin} from "../src/MemeCoin.sol";

contract ContractScript is Script {
    MemeCoin public tContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        tContract = new MemeCoin("memecoin", "MEME", 0x123456989eF98b3071e65963e6228cbDd32da382);

        vm.stopBroadcast();
    }
}
