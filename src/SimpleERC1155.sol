// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract SimpleERC1155 is ERC1155, ERC2981, Ownable {
    using Strings for uint256;

    uint256 public price = 100000000000000; //0.0001
    string public baseURI;
    // Contract name
    string public name = "SimpleERC";
    // Mapping to store price for each token ID
    mapping(uint256 => uint256) public tokenPrices;

    constructor(address _initialOwner, string memory _initialURI) Ownable(_initialOwner) ERC1155(_initialURI) {
        baseURI = _initialURI;
        _setDefaultRoyalty(owner(), 500);
        tokenPrices[1] = price; //set initial price
    }

    function adminMint(address to, uint256 tokenId, uint256 quantity) external onlyOwner {
        _mint(to, tokenId, quantity, "");
    }

    function adminMintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        external
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // Owner can set the price per token ID (in wei)
    function setPrice(uint256 tokenId, uint256 newPrice) external onlyOwner {
        tokenPrices[tokenId] = newPrice;
    }

    // Helper function for the frontend
    function getPrice(uint256 tokenId) public view returns (uint256) {
        return tokenPrices[tokenId];
    }

    // Public buy function
    function buy(uint256 tokenId, uint256 quantity) external payable {
        require(quantity > 0, "invalid quantity");
        uint256 tokenPrice = tokenPrices[tokenId];
        require(tokenPrice > 0, "token not for sale");

        require(msg.value >= tokenPrice * quantity, "insufficient payment");
        _mint(msg.sender, tokenId, quantity, "");
    }

    //owner can change the base URI
    function setBaseURI(string memory newURI) external onlyOwner {
        baseURI = newURI;
    }

    // erc1155 function
    function uri(uint256 tokenId) public view override returns (string memory) {
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    //update the default royality
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external onlyOwner {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function contractURI() public pure returns (string memory) {
        string memory json =
            '{"name": "SimpleERC1155","description":"sample simple erc1155", "image": "https://en.m.wikipedia.org/wiki/File:Wikipedia_Logo_1.0.png", "banner_image": "https://en.m.wikipedia.org/wiki/File:Wikipedia_Logo_1.0.png", "featured_image": "https://en.m.wikipedia.org/wiki/File:Wikipedia_Logo_1.0.png", "external_link": "https://wikipedia.org"}';
        return string.concat("data:application/json;utf8,", json);
    }

    // withdraw currency sent to the smart contract
    function withdrawETH() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }

    // reclaim accidentally sent tokens
    function reclaimToken(IERC20 token) public onlyOwner {
        require(address(token) != address(0));
        uint256 balance = token.balanceOf(address(this));
        token.transfer(msg.sender, balance);
    }

    function rescueERC1155(address tokenAddress, uint256 tokenId, uint256 amount, address to) external onlyOwner {
        IERC1155 token = IERC1155(tokenAddress);
        require(token.balanceOf(address(this), tokenId) >= amount, "insufficient balance");
        token.safeTransferFrom(address(this), to, tokenId, amount, "");
    }

    function rescueERC721(address tokenAddress, uint256 tokenId, address to) external onlyOwner {
        IERC721 token = IERC721(tokenAddress);
        require(token.ownerOf(tokenId) == address(this), "contract does not own the token");
        token.safeTransferFrom(address(this), to, tokenId);
    }
}
