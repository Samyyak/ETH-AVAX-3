# ETH-AVAX-3

This contract is written on Solidity and has very basic functionalities related to the creation of Reward Token.

## Description

This Smart Contract consists of simple functions and variables which helps in mapping of the data along with its minting and also helps us to burn the resources whenever needed.
## Getting Started

### Executing program

Before executing the program you have to download and keep both the ERC20 and Ownable files in the same directory as the RewardToken solidity file.

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension . Copy and paste the following code into the file:

```javascript
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

    function UseReward(address from,uint256 amount) public {
        _burn(from, amount);
    }

    // Added the transfer function
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, amount);
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


```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.0" (or another compatible version), and then click on the "Compile RewardToken.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "RewardToken" contract from the dropdown menu, and then click on the "Deploy" button.

The smart contract is deployed with the particular address being its owner which gives it the right to mint tokens but burn and transfer of the tokens can be done by different addresses which receive those tokens.The minting is done for particular addresses as there reward which can be burned by those addresses.Locking and Unlocking tokens of the ownwer can also be done.
## Authors

Samyak Jain
[@Chandigarh University](https://www.linkedin.com/in/samyak-jain-179710233/)


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
