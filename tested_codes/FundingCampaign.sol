// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// What is the project all about?
// Any peroson can come to raise fund for their projects. (with some initial asking amount.
// There are approvers who will approve the request if they find something interesting about the project.
// Contributers can be approvers who are allowed to approve the fund request raised. (they need to qualify the minimum approval amount limit.
// Only manager can finalize the fund request and max vote of the contributers.
//  Once the project is qualified in all respect the total amount will be transfered to the requester address. 


contract Campaign {
    
    struct Request {
        string description;                   // Description of the request created
        uint askingAmount;                    // what value the request is asking for.
        address recipient;                    // describes who is the recipient asking for the fund.
        mapping(address => bool) approvals;   // These are the people who have approved
        uint approvalCount;                   // These are the total number of approvals.
        bool complete;                        // Tracks of money has been send for request
    }

    address public  manager;                              // we define the manager variable.
    uint public minimumRequiredContribution;              // A variable for checking the minimum value to qualify to be contributer.
    mapping (address => Request) campaignFundRequest;     // An mapping of all the approvers is to their request is created.
    mapping(address => bool) public approvers;            // All the contributers who have provided their approvals.
    Request[] public requests;                            // An array of request is being created
    uint public approversCount;                           // counts all the contributers who have approved.

    // When we want to perform any function that is to be used in multiple places we write a fucntion and at the end of the function body we write
    // _; This tells the function to execute all the code of the parent function from there.
    modifier restricted() {
        require(msg.sender ==manager);
        _;
    }

        // We define a constructor that will set the manager/owner of the contract. 
        // also take a value and set it as the minimum value thats needed to qualify as contributor.

        // Since this contract is automatically called by another contract, here msg.sender will be the contract, 
        // but we want the person who has created the contract so we will take an address argument denoting request creator.
     constructor( uint _minimumRequiredContribution, address _requestCreator) {
        manager = _requestCreator;
        minimumRequiredContribution = _minimumRequiredContribution;
    }

    //  This function will check for the contributed value above the minimum value.
    function contributeToRequest() public payable {
        require(msg.value >= minimumRequiredContribution, "Please transact above the minimum amount required for the contribution");       // Checks if the value contributed is greater than minimum Required contribution.

        // If the condition is passed then the the sender will be added to the approvers list.
        approvers[msg.sender] = true;
        approversCount++;
    }

        // we will create a function for creating a new spending request.
        // This will be created by manager only else there can be frod.
        // To validate this we will use a modifier function which we have defined before constructor function.
    
    function createRequest(string memory _description, uint _amount, address _recipient) public restricted {
    
        campaignFundRequest[_recipient].description = _description;
        campaignFundRequest[_recipient].askingAmount = _amount;
        campaignFundRequest[_recipient].recipient = _recipient;
        campaignFundRequest[_recipient].complete = false;
        campaignFundRequest[_recipient].approvalCount = 0;
        
    }

        // The contributer will create an approveRequest for a specific contract denoted with its requests[index]
        function approveRequest(address _recipient) public {

            require(approvers[msg.sender], "I dont see you in approvers list, unfortunetly you cannot approve the request");        // This will check if the person voting is present in the approvers list. (qualified as approver).
            require(!campaignFundRequest[msg.sender].approvals[msg.sender], "You have already voted, You cannot vote multiple times.");    // this checks if the person as already not voted.
        // If the the person has not already voted then the approval will be updated.
        campaignFundRequest[_recipient].approvals[msg.sender] = true;   
        campaignFundRequest[msg.sender].approvalCount++;
    }

        // Here we finalize the request when we have enouhg number of approvals for the request.
        // ONly the manager/owner of the request creater will be able to call this.
        // We do this with the help of restricted modifier function
    function finalizeRequest(address _requestAddress) public restricted {
        // First we need to check if the request has qualified required asking amount
        require(address(this).balance >= campaignFundRequest[_requestAddress].askingAmount, "Unfortunetly the required amunt is not reached.");

        // We need to check the how many approvals we need to complete this request. also the request should not be complete. 
        // We are taking more than 50% of the approverals
        require(campaignFundRequest[_requestAddress].approvalCount > (approversCount / 2), "Cannot finalize request, Maximum contributers did not approve you");
        require(!campaignFundRequest[_requestAddress].complete, "Your fund request has already been completed");

        // Once these conditions are matched then we transfer the amount to the recipient and mark the request complete to true.
        (bool sucess, ) = _requestAddress.call{value: campaignFundRequest[_requestAddress].askingAmount}("");
        require(sucess, "The transfer was not successful, TRy Again");
        campaignFundRequest[_requestAddress].complete = true;
    }

}

        // Since the manager is only allowed to create the fund request it costs a lots of gas. 
        // Thus, We create a new contract that will call the campaign contract to use all its funtionalities. 

contract CampaignCreator {
    address[] listOfAllDeployedCampaigns;

    function createCampaign(uint minimum) public {
        Campaign newCampaign = new Campaign(minimum, msg.sender);
        listOfAllDeployedCampaigns.push(address(newCampaign));
    }

        // We also need to return the list of all address of the deployed cmapaigns.
    function getListOfAllDeployedCampaigns() public view returns ( address[] memory) {
        return listOfAllDeployedCampaigns;
    }
}

