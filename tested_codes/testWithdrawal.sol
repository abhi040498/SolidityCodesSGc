//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

// This is a testing contract to withdraw monewy to the address who has send it (the same amount)
// Account 1 has send 2 ether, and account 2 has sent 1 ether then it will withdraw the same amount to the specific address when they initiate the transaction.
    contract TestWithdraw {

// This will map the account with the balance. (to keep track of who has send what amount)
// We need to declare it public to know who has send what balance.
        mapping (address => uint) public myBalance;

// This function will send moeny to smart contract. and the balance will be updated to the specific address.
        function sendMoney() public payable {
            myBalance[msg.sender] += msg.value;
        }

// This will withdraw all the money to the person who has initiated the transaction (the amount he/she has sent earlier).
        function withdrawMoneyAll(address payable _to) public {
           uint _myBalance = myBalance[msg.sender];
           myBalance[msg.sender] = 0;
           _to.transfer(_myBalance);

        }

// Get the account balance of the smart contract.
        function getBalance() public view returns (uint){
            return address(this).balance;
        }
    }