// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

contract Draft {
    uint256 public startTime;

    function setStartTime() public {
        startTime = block.timestamp;
    }

    function elapsedSeconds() public view returns (uint256) {
        return (block.timestamp - startTime);
    }

    function elapsedMinutes() public view returns (uint256) {
        return (block.timestamp - startTime) / 1 minutes;
    }

    function blocktime() public view returns (uint256) {
        return block.timestamp;
    }
}
