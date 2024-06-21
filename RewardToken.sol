// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {

    event ApprovalLog(address indexed owner, address indexed spender, uint256 value, string message);

    struct Lock {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => Lock) private _locks;

    constructor() ERC20("RewardToken", "RTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000); 
    }

    function AddReward(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function UseReward(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        emit ApprovalLog(msg.sender, spender, amount, "Approval has been granted.");
        return super.approve(spender, amount);
    }

    function lockTokens(uint256 amount, uint256 time) public {
        require(balanceOf(msg.sender) >= amount, "ERC20: insufficient balance");
        require(_locks[msg.sender].amount == 0, "ERC20: tokens already locked");

        _locks[msg.sender] = Lock(amount, block.timestamp + time);
        _burn(msg.sender, amount);
    }

    function unlockTokens() public {
        require(_locks[msg.sender].amount > 0, "ERC20: no tokens locked");
        require(block.timestamp >= _locks[msg.sender].unlockTime, "ERC20: tokens are still locked");

        uint256 amount = _locks[msg.sender].amount;
        _locks[msg.sender].amount = 0;
        _mint(msg.sender, amount);
    }

    function getLockDetails(address _address) public view returns (uint256 amount, uint256 unlockTime) {
        Lock storage lock = _locks[_address];
        return (lock.amount, lock.unlockTime);
    }
}
