// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MemeCoin} from "../src/MemeCoin.sol";

contract ContractTest is Test {
    MemeCoin public tContract;
    address public owner = address(1);
    address public blacklistedAddress = address(2);
    address public nonBlacklistedAddress = address(3);

    function setUp() public {
        tContract = new MemeCoin("MemeCoin", "MEME", address(1));
    }

    function test_TotalSupply() public {
        console.log("Address 0:", address(0));
        console.log("Address 1:", address(1));
        console.log("Address 2:", address(2));
        console.log("Address 3:", address(3));
        assertEq(tContract.totalSupply(), 1000000000000000000000000);
    }

    function test_SimpleTransfer() public {
        assertEq(tContract.balanceOf(owner), 1000000000000000000000000);

        // Transfer 1000 tokens from the owner to the non-blacklisted address
        vm.prank(owner);
        tContract.transfer(nonBlacklistedAddress, 1000);

        // Verify the balance of the non-blacklisted address
        assertEq(tContract.balanceOf(nonBlacklistedAddress), 1000);

        vm.prank(owner);
        tContract.setBlacklist(blacklistedAddress, true);

        // Attempt to transfer 1000 tokens from the owner to the blacklisted address
        vm.expectRevert("recipient is blacklisted");
        tContract.transfer(blacklistedAddress, 1000);

        // Verify the balance of the blacklisted address remains 0
        assertEq(tContract.balanceOf(blacklistedAddress), 0);
    }

    function test_Blacklist() public {
        // Add the blacklistedAddress to the blacklist

        assertEq(tContract.balanceOf(owner), 1000000000000000000000000);

        // Verify that the address is blacklisted
        // assertFalse(tContract.isBlacklisted(blacklistedAddress));
        vm.prank(owner);
        tContract.transfer(blacklistedAddress, 1000);
        vm.prank(owner);
        tContract.transfer(nonBlacklistedAddress, 1000);
        assertEq(tContract.balanceOf(blacklistedAddress), 1000);

        vm.prank(owner);
        tContract.setBlacklist(blacklistedAddress, true);
        assertTrue(tContract.isBlacklisted(blacklistedAddress));

        // Try to transfer tokens from the blacklisted address
        vm.prank(blacklistedAddress);
        vm.expectRevert("sender is blacklisted");
        tContract.transfer(nonBlacklistedAddress, 1000);

        // Verify that a non-blacklisted address can still transfer tokens
        vm.prank(nonBlacklistedAddress);
        tContract.transfer(owner, 1000);

        // Remove the blacklisted address from the blacklist
        vm.prank(owner);
        tContract.setBlacklist(blacklistedAddress, false);

        // // Verify that the address is no longer blacklisted
        assertFalse(tContract.isBlacklisted(blacklistedAddress));

        vm.prank(blacklistedAddress);
        tContract.transfer(nonBlacklistedAddress, 900);
        assertEq(tContract.balanceOf(blacklistedAddress), 100);
    }
}
