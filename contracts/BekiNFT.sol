// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BekiNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => string) private tokenUris;
    mapping(uint16 => uint256) private tierPrices;
    mapping(uint16 => uint16) private tierDiscounts;
    mapping(uint256 => uint16) private tokenTiers;
    address private marketplaceAddress;
    
    constructor(address initialOwner) ERC721("BekiNFT", "BKNFT") Ownable(initialOwner) {
        tierPrices[1] = 1000;
        tierPrices[2] = 2000;
        tierPrices[3] = 3000;
        tierDiscounts[1] = 20;
        tierDiscounts[2] = 30;
        tierDiscounts[3] = 50;
    }

    function safeMint(string memory _uri, uint16 _tier, address _to) public onlyOwner
    {
        require(bytes(_uri).length > 0, "Uri can not be empty!");
        uint256 tokenId =_nextTokenId++;
        tokenTiers[tokenId] = _tier;
        tokenUris[tokenId] = _uri;
        _safeMint(_to, tokenId);
    }

    function setMarketplaceAddress(address _marketplaceAddress) public 
    {
        require(_marketplaceAddress != address(0), "Invalid marketplace address.");
        marketplaceAddress = _marketplaceAddress;
    }

    function setTierPrice(uint16 _tier, uint256 _price) public
    {
        tierPrices[_tier] = _price;
    }

    function setTierDiscount(uint16 _tier, uint16 _discount) public
    {
        tierDiscounts[_tier] = _discount;
    }

    function setTokenTier(uint256 _tokenId, uint16 _tier) public
    {
        tokenTiers[_tokenId] = _tier;
    }

    function getTokenPrice(uint256 _tokenId) public view returns (uint256)
    {
        uint16 tier = tokenTiers[_tokenId];
        return tierPrices[tier];
    }

    function getTokenTier(uint256 _tokenId) public view returns (uint16)
    {
        return tokenTiers[_tokenId];
    }

    function getTotalNFT() public view virtual returns (uint256)
    {
        return _nextTokenId;
    }
}
