// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MemeCoin is ERC20Permit, Ownable {
    mapping(address => bool) private _blacklist;

    constructor() ERC20("MemeCoin", "MEME") ERC20Permit("MemeCoin") {
        _mint(msg.sender, 21_000_000 * 10 ** decimals()); // Mint the initial supply to the contract deployer
    }

    // Override the _beforeTokenTransfer hook to prevent transfers from or to blacklisted addresses
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!_blacklist[from], "ERC20: sender is blacklisted");
        require(!_blacklist[to], "ERC20: recipient is blacklisted");
        super._beforeTokenTransfer(from, to, amount);
    }

    // Function to blacklist an address, restricted to accounts with the blacklist role
    function blacklist(address account) external onlyOwner {
        _blacklist[account] = true;
    }

    // Function to remove an address from the blacklist, restricted to accounts with the blacklist role
    function unblacklist(address account) external onlyOwner {
        require(hasRole(BLACKLIST_ROLE, msg.sender), "ERC20: must have blacklist role to unblacklist");
        _blacklist[account] = false;
    }

    // Function to check if an address is blacklisted
    function isBlacklisted(address account) public view returns (bool) {
        return _blacklist[account];
    }
}
