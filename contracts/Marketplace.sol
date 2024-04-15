// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "contracts/BekiNFT.sol";
import "contracts/BekiToken.sol";

contract Marketplace
{
    BekiNFT public bekiNFT;
    BekiToken public bekiToken;

    enum Tier {Tier1, Tier2, Tier3}
    struct NFTPrice {
        uint256 tokenId;
        Tier tier;
        uint256 price;
        address buyer;
        address seller;
        uint256 discount;
    }

    NFTPrice[] private nftPrices;
    NFTPrice[] private nftSold;
    mapping(Tier => uint256) private tierPrice;

    constructor(address bekiNFTAddress, address bekiTokenAddress)
    {   
        tierPrice[Tier.Tier1] = 1000;
        tierPrice[Tier.Tier2] = 2000;
        tierPrice[Tier.Tier3] = 3000;
        bekiNFT = BekiNFT(bekiNFTAddress);
        bekiToken = BekiToken(bekiTokenAddress);
    }

    function addNFT(address seller, uint256 tokenId, uint256 tier, uint256 discount) external
    {
        // require();
        nftPrices.push(NFTPrice({
            tokenId : tokenId,
            tier : Tier(tier),
            price : tierPrice[Tier(tier)],
            buyer: address(0),
            seller: seller,
            discount: discount
        }));
    }

    function discountNFT(uint256 tokenId, uint256 discount) external 
    {
        uint256 index = findTokenIndex(tokenId);
        nftPrices[index].discount = discount;
    }

    function buyBekiNFT(uint tokenId) public payable 
    {
        // buyer is msg.sender
        // seller is owner tokenId
        // price is in NFTPrice
        
        // -1.find NFT by tokenId
        // 0.check buyer balance >= BekiNFT price (with discount)
        // 1.approve Bekitoken for seller
        // 2.approve BekiNFT for buyer
        // 3.transfer BekiNFT from seller to buyer
        // 4.transfer BekiToken from buyer to seller
        // 5.calculate price by discount (finish after)

        // -1.
        uint256 nftIndex = findTokenIndex(tokenId);
        NFTPrice memory nft = nftPrices[nftIndex];
        // 0.
        uint256 priceNFT = nft.price * (100 - nft.discount) / 100;
        uint256 buyerBalance = bekiToken.balanceOf(msg.sender);
        require(buyerBalance >= priceNFT, "Balance is not enough!");
        // 1.
        bekiToken.apporveForMaketplace(msg.sender, address(this), priceNFT);
        // 2.
        address seller = bekiNFT.ownerOf(tokenId);
        bekiNFT.approveForMarketplace(seller, address(this), tokenId);
        // 3.
        bekiNFT.safeTransferFrom(seller, msg.sender, tokenId);
        // 4.
        bekiToken.transferFrom(msg.sender, seller, priceNFT);
        // 5.
        nftPrices[nftIndex].buyer = msg.sender;
        nftSold.push(nftPrices[nftIndex]);
    }

    function getTokenSold() public view returns (NFTPrice[] memory)
    {
        return nftSold;
    }

    function getTokenBoughtByAddress() public view returns(NFTPrice[] memory bought)
    {
        uint256 count = 0;
        for (uint256 index = 0; index < nftSold.length; index++) {
            if (msg.sender == nftSold[index].buyer) {
                count++;
            }
        }

        bought = new NFTPrice[](count);
        uint256 boughtIndex = 0;
        for (uint256 index = 0; index < nftSold.length; index++) {
            if (msg.sender == nftSold[index].buyer) {
                bought[boughtIndex] = nftSold[index];
                boughtIndex++;
            }
        }
    } 

    function getDiscountPrice(uint256 tokenId) public view returns (uint256 price)
    {
        uint256 index = findTokenIndex(tokenId);
        price = nftPrices[index].price * (100- nftPrices[index].discount) / 100;
    }

    function getAllToken() public view returns (NFTPrice[] memory)
    {
        return nftPrices;
    }

    function getBekiTokenBalance(address owner) public view returns (uint256) {
        return bekiToken.balanceOf(owner);
    }

    function getBekiNFTBalance(address owner) public view returns (uint256)
    {
        return bekiNFT.balanceOf(owner);
    }

    function findToken(uint256 tokenId) public view returns (NFTPrice memory nft)  {
        for(uint i=0; i < nftPrices.length; i++){
            if (tokenId == nftPrices[i].tokenId) {
                nft = nftPrices[i];
                break;
            }
        }
    }

    function findTokenIndex(uint256 tokenId) private view returns (uint256 index)  {
        for(uint i=0; i < nftPrices.length; i++){
            if (tokenId == nftPrices[i].tokenId) {
                index = i;
                break;
            }
        }
    }
}
