// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

interface IBekiNFT {
    function getTokenPrice(uint256 _tokenId) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function approve(address _to, uint256 _tokenId) external;
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;
    function setPriceTokenBuy(uint256 _tokenId) external;
}

interface IBekiToken {
    function balanceOf(address _owner) external view returns (uint256);
    function approve(address _spender, uint256 _value) external;
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);
    function decimalToken(uint256 _value) external;
    function decimals() external returns (uint8);
    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256);
}

contract Marketplace is ERC721Holder, Ownable {
    address private bekiNFTAddress;
    address private bekiTokenAddress;
    uint256 private decimals;
    mapping(address => uint256) private nftBuyValue;

    constructor(
        address _owner,
        address _bekiNFTAddress,
        address _bekiTokenAddress
    ) Ownable(_owner) {
        bekiNFTAddress = _bekiNFTAddress;
        bekiTokenAddress = _bekiTokenAddress;
        decimals = 10 ** IBekiToken(bekiTokenAddress).decimals();
    }

    function setNFTAddress(address _bekiNFTAddress) external onlyOwner {
        bekiNFTAddress = _bekiNFTAddress;
    }

    function setTokenAddress(address _bekiTokenAddress) external onlyOwner {
        bekiTokenAddress = _bekiTokenAddress;
    }

    function setPriceTokenBuy(uint256 _tokenId) public onlyOwner {
        IBekiNFT(bekiNFTAddress).setPriceTokenBuy(_tokenId);
    }

    function buyBekiNFT(uint256 _tokenId) public {
        address owner = IBekiNFT(bekiNFTAddress).ownerOf(_tokenId);
        require(
            owner == address(this),
            "Marketplace: Market not owner of nft."
        );
        uint256 priceNFTWithDecimal = IBekiNFT(bekiNFTAddress).getTokenPrice(
            _tokenId
        ) * decimals;
        payToken(priceNFTWithDecimal, owner);
        IBekiNFT(bekiNFTAddress).safeTransferFrom(owner, msg.sender, _tokenId);
        uint256 currentBuy = nftBuyValue[msg.sender];
        nftBuyValue[msg.sender] = currentBuy + priceNFTWithDecimal;
    }

    function payToken(uint256 _valueWithDecimal, address _owner) public {
        require(
            IBekiToken(bekiTokenAddress).balanceOf(msg.sender) >=
                _valueWithDecimal,
            "Marketplace: Buyer balance not enough."
        );
        require(
            IBekiToken(bekiTokenAddress).allowance(msg.sender, address(this)) >=
                _valueWithDecimal,
            "Marketplace: Need to approve token."
        );
        require(
            IBekiToken(bekiTokenAddress).transferFrom(
                msg.sender,
                _owner,
                _valueWithDecimal
            ),
            "Marketplace: Transfer token error."
        );
    }

    function getPriceBoughtOfAddress(
        address _buyer
    ) public view returns (uint256) {
        return nftBuyValue[_buyer];
    }
}
