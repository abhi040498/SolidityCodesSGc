// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// What this BlockchainMessenger does?

// Store a string on the blockchain.
// It is readable to everyone, but it's writable by the person who deployed the smart contract.
// Know how many times the msg was updated.

    contract TheMsgBlockchain {
        string public message;          // This is the message.
        uint public messageCount;       // This is the message count. updates everytime msg is updated.
        address public  owner;          // This is the owner of the contract. who is only allowed to send the message.

        constructor() {
            owner = msg.sender;
          
        }

//  This function is used to update the message. and the message counter.
        function sendMessage( string memory _message) public checkMsgOwner {
            message = _message;
            messageCount++;
         }
// Here a modifier is used to check if this is the message sender is the owner or not.
         modifier checkMsgOwner {
             require(msg.sender == owner);
             _;
         }
    }
