//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;


// What this contract will do?

// Have an account that sends 1 eth to the smart contract
// Will be able to see the balance.
// Withdraw from the smart contract.
// Withdraw from the smart contract to a apecific address. 

contract RecieveAndWithdraw {
    uint public accountBalance;         // stores the balance of the owner Account.
    uint  contractBalance;              // stores the balance of the contract.
    address public owner;
    uint public depositeCount;

// This constructor is defined to capture the owner who deployed the contract.
    constructor() {
        owner = msg.sender;
    }

// This function will allow sending money to the smart contract. and updates the balance. 
// It also updates how many times the token was sent to the contract.
    function sendEtherToSmartContract() public payable checkOwner{
        contractBalance += msg.value;
        depositeCount++;
    }

// This function will get and display the balance of the smart contract.
// Since this is view only function we can mark it as view.
    function getSmartContractBalance () public view returns (uint) {
        return address(this).balance;
    }

// This function will get and display the balance of the smart contract.
// Since this is view only function we can mark it as view.
    function getOwnerAccounttBalance () public view returns (uint) {
        return owner.balance;
    }

// This function will withdraw all the balance from the smart contract and transfer to the account.

    function withdrawContractBalance() public returns (bool) {
        address payable senderAccount = payable(msg.sender);
        senderAccount.transfer(contractBalance);

        return true;
    }

// This function will withdraw all the balance from the smart contract and transfer to a specific account.
    function withdrawToSpecificAccount (address payable  toSpecificAccount) public returns (bool) {
        toSpecificAccount.transfer(contractBalance);
       
        return true;
    }

// This function checks for the owner.
    modifier checkOwner {
        require(msg.sender == owner);
        _;
    }

}