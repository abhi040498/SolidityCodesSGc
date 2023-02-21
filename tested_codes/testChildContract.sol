//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

// This is a for testing child smart contract. 
// One smart contract calls another smart contract.

contract TestChildContract {
    

    childPayment public childPaymentVar;

// We will create a smart contract that will call another smart contract and pass its value.
// This function will call an instance of the childPayment and store its value.(address and transfered amount)
// And will generate an address through which we can look into the childPaymant contract.
    function makePayemntParent() public payable  {
        childPaymentVar = new childPayment (msg.sender, msg.value);
    }
    
}

// With the address recieved from the above function we can call the childContract 
// When we call this childPayment contract to see different values in it.
contract childPayment{
        address public recievedFrom;
        uint public valueRecieved;

        constructor(address _recievedFrom, uint _valueRecieved) {
            recievedFrom = _recievedFrom;
            valueRecieved = _valueRecieved;
        }
    }