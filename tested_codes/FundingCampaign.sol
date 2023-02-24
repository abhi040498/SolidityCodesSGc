// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Campaign {
    
    struct Request {
        string description;                   // Description of the request created
        uint askingAmount;                           // what value the request is asking for.
        address recipient;                    // describes who is the recipient asking for fund.
        mapping(address => bool) approvals;   // These are the people who have approved
        uint approvalCount;                   // These are the total number of approvals.
        bool complete;                        // Tracks of money has been send for request
    }

    address public  manager;            // we define the manager variable.
    uint public minimumRequiredContribution;    // A variable for checking the minimum value to qualify to be contributer.
    // address[] public approvers;         // An array of all the approvers is created.
    mapping(address => bool) public approvers; // All the contributers who have provided their approvals.
    Request[] public requests;          // An array of request is being created
    uint public approversCount;         // counts all the contributers who have approved.

    // When we want to perform any function that is to be used in multiple places we write a fucntion and at the end of the function body we write
    // _; This tells the function to execute all the code of the parent function from there.
    modifier restricted() {
        require(msg.sender ==manager);
        _;
    }

// We define a constructor that will set the manager/owner of the contract. 
// also take a value and set it as the minimum value thats needed to qualify as contributor.
     constructor( uint _minimumRequiredContribution) {
        manager = msg.sender;
        minimumRequiredContribution = _minimumRequiredContribution;
    }

//  This function will check for the contributed value above the minimum value.
    function contributeToRequest() public payable {
        require(msg.value > minimumRequiredContribution);       // Checks if the value contributed is greater than minimum Required contribution.

        // If the condition is passed then the the sender will be added to the approvers list.
        approvers[msg.sender] = true;
        approversCount++;
    }

}