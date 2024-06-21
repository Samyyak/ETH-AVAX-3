// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {

    constructor() ERC20("RewardToken", "RTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 10 ** decimals()); 
    }

    function AddReward(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }


    function UseReward(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Users can transfer tokens using the standard ERC20 transfer functionality
}

