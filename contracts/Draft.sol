// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

contract Draft {
    uint256 public minimumUsd = 50;

    function fun() public payable {
        console.log("value: ", msg.value);
        require(msg.value >= 50, "Did not send enough");

        
    }

    function msgValue() public payable returns (uint256) {
        return msg.value;
    }

    function msgData() public view {
        console.log("Transferring from %s to %s %s tokens", msg.sender);
    }

    function processData() public pure returns (bytes memory) {
        return msg.data; // Trả về dữ liệu đầu vào của giao dịch
    }
}
