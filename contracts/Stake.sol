// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "hardhat/console.sol";

interface IBekiNFT {
    function ownerOf(uint256 _tokenId) external returns (address);
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;
    function getPriceTokenBuy(uint256 _tokenId) external view returns (uint256);
}

interface IBekiToken {
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
    function decimals() external view returns (uint256);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function approve(address _spender, uint256 _value) external;
}

// tạm chưa thêm Ownable
contract Stake is ERC721Holder {
    uint16 private percent;
    address private bekiTokenAddress;
    address private bekiNFTAddress;
    uint256 private constant SECONDS_PER_DAY = 1 days;

    mapping(uint256 => address) private oldOwnerTokens; // save old owner of nft
    mapping(uint256 => uint256) private timeSendNFTs; // time send nft to stake

    constructor(
        address _bekiNFTAddress,
        address _bekiTokenAddress,
        uint16 _percent
    ) {
        percent = _percent;
        bekiNFTAddress = _bekiNFTAddress;
        bekiTokenAddress = _bekiTokenAddress;
    }

    function setPercent(uint16 _percent) public {
        require(
            percent >= 0 && percent <= 10000,
            "Stake: Invalid percent profit."
        );
        percent = _percent;
    }

    function sendTokenStake(uint256[] memory _tokenIds) public {
        require(
            _tokenIds.length > 0 && _tokenIds.length <= 3,
            "Stake: Invalid number length nfts."
        );
        require(
            checkTokenOwner(_tokenIds, msg.sender),
            "Stake: Has invalid token"
        );
        for (uint8 index = 0; index < _tokenIds.length; index++) {
            // transfer nft
            IBekiNFT(bekiNFTAddress).safeTransferFrom(
                msg.sender,
                address(this),
                _tokenIds[index]
            );
            // save time
            oldOwnerTokens[_tokenIds[index]] = msg.sender;
            timeSendNFTs[_tokenIds[index]] = block.timestamp;
        }
    }

    function checkTokenOwner(
        uint256[] memory _tokenIds,
        address _owner
    ) internal returns (bool) {
        for (uint256 index = 0; index < _tokenIds.length; index++) {
            if (IBekiNFT(bekiNFTAddress).ownerOf(_tokenIds[index]) != _owner)
                return false;
        }
        return true;
    }

    function checkTokenOldOwner(
        uint256[] memory _tokenIds
    ) internal view returns (bool) {
        for (uint256 index = 0; index < _tokenIds.length; index++) {
            if (oldOwnerTokens[_tokenIds[index]] != msg.sender) return false;
        }
        return true;
    }

    function getStakeValueAndNFT(uint256[] memory _tokenIds) public {
        require(
            _tokenIds.length > 0 && _tokenIds.length <= 3,
            "Stake: Invalid number length nfts."
        );
        require(
            checkTokenOwner(_tokenIds, address(this)),
            "Stake: Has invalid token."
        );
        require(
            checkTokenOldOwner(_tokenIds),
            "Stake: Has invalid token old owner."
        );

        for (uint256 index = 0; index < _tokenIds.length; index++) {
            // pay profit
            uint256 tokenProfit = getStakeValueOneNFTWithDecimal(_tokenIds[index]);
            require(
                IBekiToken(bekiTokenAddress).balanceOf(address(this)) >=
                    tokenProfit,
                "Stake: Token not enough."
            );
            IBekiToken(bekiTokenAddress).transfer(
                msg.sender,
                tokenProfit
            );

            // pay nft
            IBekiNFT(bekiNFTAddress).safeTransferFrom(
                address(this),
                msg.sender,
                _tokenIds[index]
            );
        }
    }

    function showStakeValue(uint256 _tokenId) public pure returns (uint256) {
        return _tokenId;
    }

    function getStakeValueOneNFTWithDecimal(
        uint256 _tokenId
    ) public view returns (uint256) {
        uint256 priceBuy = IBekiNFT(bekiNFTAddress).getPriceTokenBuy(_tokenId);
        uint256 decimals = 10 ** IBekiToken(bekiTokenAddress).decimals();
        uint256 timeSent = block.timestamp - timeSendNFTs[_tokenId];
        uint256 timeSentDay = timeSent / SECONDS_PER_DAY;

        return priceBuy * percent / 10000 * timeSentDay * decimals;
    }
}
