//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

// This is a for testing structure and mapping in smart contract. 
// Only the msg sender who has the balance can withdraw that very amount to any address

    contract TestStructAndMap {
// This will record the transaction of details.
        struct Transaction {
            uint transactionAmount;
            uint transactionTimestamp;
        }

// This will record the balance details.
        struct Balance {
            uint totalBalance;
            uint depositCount;
            uint withdrawalCount;
            mapping (uint => Transaction) deposites;
            mapping (uint => Transaction) withdrawals;
        }

        mapping (address => Balance) balances;

        function depositeMoney() public payable {
// When we deposite money we update the balance structure.

// update the totalbalance as the msg value.
            balances[msg.sender].totalBalance += msg.value;
// Updates the deposite mapping with transactionAmount and transactionTimestamp.
            Transaction memory deposite = Transaction(msg.value, block.timestamp);
// Now we update the desposite the with the index as deposite count variable. 
            balances[msg.sender].deposites[balances[msg.sender].depositCount] = deposite;
// Once the deposite is completed we will update the deposite counter for the next updates.
            balances[msg.sender].depositCount++;
            
        }

        function withdrawMoney(address payable _withdrawalAddress, uint _withdrawalAmount) public {
// When we deposite money we update the balance structure.

// update the totalbalance as the withdrawal amount.
            balances[msg.sender].totalBalance -= _withdrawalAmount;
// Updates the withdrawal mapping with transactionAmount and transactionTimestamp.
            Transaction memory withdrawal = Transaction(_withdrawalAmount, block.timestamp);
// Now we update the  withdrawal balance with the index as withdrawal count variable.            
            balances[msg.sender].withdrawals[balances[msg.sender].withdrawalCount] = withdrawal;
// Once the withdrawal is completed we will update the withdrawal counter for the next updates.
            balances[msg.sender].withdrawalCount++;
// Now we can transfer the withdrawal amount to the withdrawal address
            _withdrawalAddress.transfer(_withdrawalAmount);
        }

    }