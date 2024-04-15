// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/Marketplace.sol";

contract BekiNFT is ERC721, ERC721Enumerable, Ownable {
    uint256 private _nextTokenId;
    enum Tier {Tier1, Tier2, Tier3}
    uint256[] private nftSelled;
    mapping(Tier => uint256) public tierPrice;

    Marketplace marketplace;
    
    constructor(address initialOwner) ERC721("BekiNFT", "BKNFT") Ownable(initialOwner) {
        tierPrice[Tier.Tier1] = 1000;
        tierPrice[Tier.Tier2] = 2000;
        tierPrice[Tier.Tier3] = 3000;
    }

    function safeMint(address to) public onlyOwner
    {
        uint256 tokenId =_nextTokenId++;
        _safeMint(to, tokenId);
    }

    function connectToMarket(address marketAddress) public 
    {
        marketplace = Marketplace(marketAddress);
    }

    function sellNFT(uint256 tokenId, Tier tier, uint256 discount) public 
    {
        marketplace.addNFT(msg.sender, tokenId, uint256(tier), discount);
    }

    function setDiscount(uint256 tokenId, uint256 discount) public 
    {
        marketplace.discountNFT(tokenId, discount);
    }

    function getAllTokenSelled() public view returns(uint[] memory)
    {
        return nftSelled;
    }

    function addTokenSelled(uint256 tokenId) external 
    {
        nftSelled.push(tokenId);
    }

    function approveForMarketplace(address from, address to, uint256 tokenId) external 
    {
        _approve(to, tokenId, from);
    }

    function _update(address to, uint256 tokenId, address auth)
    internal 
    override (ERC721, ERC721Enumerable)
    returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
