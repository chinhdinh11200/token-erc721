// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract BekiToken is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("BekiToken", "BEKI")
        Ownable(initialOwner)
        ERC20Permit("BekiToken")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, decimalToken(amount));
    }

    function apporveForMaketplace(address from, address to, uint256 amount) external 
    {
        _approve(from, to, decimalToken(amount));
    }

    function decimalToken(uint256 amount) public view /* pure */ returns (uint256){
        return amount * 10 ** decimals(); //1e18;
    }
}
