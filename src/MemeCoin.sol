// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MemeCoin is ERC20, Ownable, ERC20Permit {
    mapping(address => bool) private _blacklist;
    uint256 public version = 1234;

    constructor(string memory _name, string memory _symbol, address _initialOwner)
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
        ERC20Permit(_name)
    {
        _mint(_initialOwner, 1_000_000 * 10 ** decimals()); // Mint the initial supply to the contract deployer
    }

    function _update(address from, address to, uint256 value) internal virtual override {
        require(!_blacklist[from], "sender is blacklisted");
        require(!_blacklist[to], "recipient is blacklisted");
        super._update(from, to, value);
    }

    // Function to blacklist an address, restricted to accounts with the blacklist role
    function setBlacklist(address account, bool isBlacklist) external onlyOwner {
        _blacklist[account] = isBlacklist;
    }

    // Function to check if an address is blacklisted
    function isBlacklisted(address account) public view returns (bool) {
        return _blacklist[account];
    }
}
