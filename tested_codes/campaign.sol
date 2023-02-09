// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

// We create a new campaign factory that will call the campaign contract. 

contract CampaignFactory {
    address[] public deployedCampaigns;
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

// We also need to return the list of all address of the deployed cmapaigns.
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}


contract Campaign {
    
    struct Request {
        string description;                   //Description of the request created
        uint value;                           // what value the request is asking for.
        address recipient;                    // describes whonid the recipient asking for.
        bool complete;                        //Tracks of money has been send for request
        uint approvalCount;                   //These are the total number of approvals.
        mapping(address => bool) approvals;   //These are the people who have approved
    }

    address public  manager;            // we define the manager variable.
    uint public minimumContribution;    // A variable for checking the minimum value to qualify to be contributer.
    // address[] public approvers;         // An array of all the approvers is created.
    mapping(address => bool) public approvers; // All the contributers who have provided their approvals.
    Request[] public requests;          // An array of request is being created
    uint public approversCount;

    // When we want to perform any function that is to be used in multiple places we write a fucntion and at the end of the function body we write
    // _; This tells the function to execute all the code of the parent function from there.
    modifier restricted() {
        require(msg.sender ==manager);
        _;
    }

// We define a constructor function that takes that will set the manager/owner of the contract. 
// also take a value and set it as the minimum value thats needed to qualify as contributor.
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

//  This function will check for the contributed value above the minimum value.
    function contribute() public payable {
        require(msg.value > minimumContribution);       // Checks if the value contributed is greater than minimum contribution.

        // If the condition is passed then the the sender will be added to the approved list.
        approvers[msg.sender] = true;
        approversCount++;
    }

// we will create a function for creating a new spending request.
// This will be created by manager only else there can be frod.
// To validate this we will use a modifier function which we have defined before constructor function.
    
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        // There is an alternate way to call restrict struct.
        // Request(description, value, recipient, false);
        // This will take the areguments in the defined order.

// Once this request is created, we need to push the request to Request array so that we can have multiple requests created.
        requests.push(newRequest);
    }

// The contributer will create an approveRequest for a specific contract denoted with its requests[index]
    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);        // This will check if the person voting is present in the approvers list. (qualified as approver).
        require(!request.approvals[msg.sender]);    // this checks if the person as already not voted.
// If the the person has not already voted then the spproval will be updated.
        request.approvals[msg.sender] = true;   
        request.approvalCount++;
    }

// Here we finalize the request when we have enouhg number of approvals for the request.
// ONly the manager/owner of the request creater will be able to call this.
// We do this with the help of restricted modifier function
    function finalizeRequest(uint index) public restricted {
        // We request to point to the same structure, so we use storage. 
        Request storage request = requests[index];

// We need to check the how many approvals we need to complete this request. also the request should not be complete. 
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

// Once these conditions are matched then we transfer the amount to the recipient adn mark the request complete to true.
        request.recipient.transfer(request.value);
        request.complete = true;
    }

}