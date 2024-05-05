// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract BekiNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    address private marketplace;
    mapping(uint256 => string) private tokenUris;
    mapping(uint16 => uint256) private tierPrices;
    mapping(uint16 => uint16) private tierDiscounts;
    mapping(uint256 => uint16) private tokenDiscounts;
    mapping(uint256 => uint16) private tokenTiers;
    mapping(uint256 => uint256) private priceTokenBuy;

    constructor(
        address _initialOwner
    ) ERC721("BekiNFT", "BKNFT") Ownable(_initialOwner) {
        tierPrices[1] = 1000;
        tierPrices[2] = 2000;
        tierPrices[3] = 3000;
        tierDiscounts[1] = 1000;
        tierDiscounts[2] = 2000;
        tierDiscounts[3] = 3000;
    }

    function safeMint(
        string memory _uri,
        uint16 _tier,
        address _to
    ) public onlyOwner {
        require(bytes(_uri).length > 0, "NFT: Uri can not be empty!");
        uint256 tokenId = _nextTokenId++;
        tokenTiers[tokenId] = _tier;
        tokenUris[tokenId] = _uri;
        tokenDiscounts[tokenId] = 0;
        _safeMint(_to, tokenId);
    }

    function setTierPrice(uint16 _tier, uint256 _price) external onlyOwner {
        tierPrices[_tier] = _price;
    }

    function setMarketplace(address _marketplace) external onlyOwner {
        require(_marketplace != address(0), "NFT: Address can not be empty!");
        marketplace = _marketplace;
    }

    function setTierDiscount(
        uint16 _tier,
        uint16 _discount
    ) external onlyOwner {
        require(
            _discount >= 0 && _discount <= 10000,
            "NFT: Invalid token tier discount."
        );
        require(
            _tier == 1 || _tier == 2 || _tier == 3,
            "NFT: Tier invalid value."
        );
        tierDiscounts[_tier] = _discount;
    }

    function setTokenDiscount(
        uint16 _tokenId,
        uint16 _discount
    ) external onlyOwner {
        require(
            _discount >= 0 && _discount <= 10000,
            "NFT: Invalid token discount."
        );
        tokenDiscounts[_tokenId] = _discount;
    }

    function setTokenTier(uint256 _tokenId, uint16 _tier) external onlyOwner {
        tokenTiers[_tokenId] = _tier;
    }

    function setPriceTokenBuy(uint256 _tokenId) public {
        require(
            msg.sender == marketplace,
            "NFT: Only marketplace can be access."
        );
        uint16 tier = tokenTiers[_tokenId];
        uint256 price = tierPrices[tier];
        priceTokenBuy[_tokenId] = price;
    }

    function getTokenPrice(uint256 _tokenId) public view returns (uint256) {
        uint16 tier = tokenTiers[_tokenId];
        uint256 price = tierPrices[tier];
        uint16 discount = tierDiscounts[tier];
        if (tokenDiscounts[_tokenId] > 0) {
            discount = tokenDiscounts[_tokenId];
        }
        return price - (price * discount) / 10000;
    }

    function getTokenTier(uint256 _tokenId) public view returns (uint16) {
        return tokenTiers[_tokenId];
    }

    function getTotalNFT() public view virtual returns (uint256) {
        return _nextTokenId;
    }

    function getTokenDiscount(uint256 _tokenId) public view returns (uint16) {
        return tokenDiscounts[_tokenId];
    }

    function getTierDiscount(uint16 _tier) public view returns (uint256) {
        return tierDiscounts[_tier];
    }

    function getPriceTokenBuy(uint256 _tokenId) public view returns (uint256) {
        return priceTokenBuy[_tokenId];
    }
}
