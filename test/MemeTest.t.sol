// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleERC1155} from "../src/SimpleERC1155.sol";

contract ERC1155Test is Test {
    SimpleERC1155 public tContract;
    address public owner = address(1);

    function setUp() public {
        tContract = new SimpleERC1155(address(1), "https://base.uri");
    }

    function test_SimpleTest() public {
        console.log("Address 0:", address(0));
        console.log("Address 1:", address(1));
        console.log("Address 2:", address(2));
        console.log("Address 3:", address(3));
        assertEq(tContract.getPrice(1), 100000000000000);
    }

    function test_SimpleAdminMint() public {
        vm.prank(owner);
        tContract.adminMint(address(2), 1, 5);

        // Verify the balance of the non-blacklisted address
        assertEq(tContract.balanceOf(address(2), 1), 5);
    }
}
