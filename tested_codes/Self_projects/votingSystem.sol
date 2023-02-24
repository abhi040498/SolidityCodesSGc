// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

// Distributed voting system. 
// No vote = age<18
// vote=1 =>18<age<=60
// Vote = 1.2 * (61 to 70)
// Last election = 2000, 2005, 2010, 2015, 2020.

// Initial 2000, 
// Anyone can register. (proper details)
// CAN ONLY VOTE ON ABOVE CRITERIA.
// Can only register till 1 day before voting.( cannot register on voting day) (eg 10th april.)
// 11th to next 9th april only register no vote.


contract SimpleVotingSyatem {

    address public owner;

    struct Person {
        string personName;
        string personCity;
        uint8 personAge;
        string personGender;
        string personQualification;
        string personID;
        uint8 personVotePower;
        
    }
   struct Party {
       string partyName;
       string partyCity;
       string partySymbol;
       string partyID;    
   } 

   mapping (address => bool) partyVote;

   mapping (address => Party) individialParty;
   mapping (address => Person) individialPerson;
   mapping (address => bool) personHasRegistered;
   mapping (address => bool) partyHasRegistered;
   mapping (uint => address) registeredPartyList;
   mapping (uint => address) registeredPersonList;
   mapping (address => mapping (address => bool)) hasVoted;
   mapping (address => uint) votesToParty;
   mapping (address => uint) hasMaxVote;
   address private winnerParty;
   uint8 public partyCount;
   uint8 public personCount;
   uint electionVotingDate;
//    uint personRegistrationDate;
    

   constructor () {
       owner = msg.sender;
   }
   function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day){
       
   }

//    function decimals() public view returns (uint8){}

// Registering the person with all details.
   function registerPerson (string memory _personName, string memory _personCity, uint8  _personAge, string memory _personGender, string memory _personQualification, string memory _personID) public {
       require(personHasRegistered[msg.sender] != true, "You have already registered, no need to register for 2nd time");
       require(partyHasRegistered[msg.sender] !=true , "You cannot register as a person, you are an individual party");
       individialPerson[msg.sender].personName = _personName;
       individialPerson[msg.sender].personCity = _personCity;
       individialPerson[msg.sender].personAge = _personAge;
       individialPerson[msg.sender].personGender = _personGender;
       individialPerson[msg.sender].personQualification = _personQualification;
       individialPerson[msg.sender].personID = _personID;
       personHasRegistered[msg.sender] = true;
       registeredPersonList[personCount] = msg.sender;
       personCount++;
       assigningVotePowertoVoter();
   }

// Registering the party with all details.
    function registerParty (string memory _partyName, string memory _partyCity, string memory _partySymbol, string memory _partyID) public {
        require(personHasRegistered[msg.sender] !=true , "You cannot register as a party, you are an individual person");
        require(partyHasRegistered[msg.sender] != true, "You have already registered, no need to register for 2nd time");
        individialParty[msg.sender].partyName = _partyName;
        individialParty[msg.sender].partyCity = _partyCity;
        individialParty[msg.sender].partySymbol = _partySymbol;
        individialParty[msg.sender].partyID = _partyID;
        registeredPartyList[partyCount] = msg.sender;
        partyHasRegistered[msg.sender] = true;
        partyCount++;
    }
   
//    checking and assigning votePower.
    function assigningVotePowertoVoter () private {
        if(individialPerson[msg.sender].personAge >= 18 && individialPerson[msg.sender].personAge <=60) {
            individialPerson[msg.sender].personVotePower = 10;
        } else if(individialPerson[msg.sender].personAge > 60) {
            individialPerson[msg.sender].personVotePower = 12;
        } 
    }
// function to set date of the election 
    function setVotingDateOfElection (uint _electionVotingDate) public {
        require(msg.sender == owner, "Only the owner of the contract can set the election voting date");
        electionVotingDate = _electionVotingDate;

    }
 
// function to caste Vote.
    function casteVote (address _partyAddress) public {
        require(hasVoted[msg.sender][_partyAddress] == false, "You have already voted, you cannot vote multiple times.");
        require(personHasRegistered[msg.sender], "Please register to cast vote.");
        require(individialPerson[msg.sender].personAge > 17, "You cannot vote, you are below voting Age (18)");
        hasVoted[msg.sender][_partyAddress] = true;
        votesToParty[_partyAddress] += individialPerson[msg.sender].personVotePower;
        if( votesToParty[_partyAddress] > hasMaxVote[_partyAddress]) {
            hasMaxVote[_partyAddress] = votesToParty[_partyAddress];
            winnerParty = _partyAddress;
        }
    }

// function to check winner.
    function checkWinner() public view returns(address )  {
        require(msg.sender == owner, "You are not the owner, Only the owner is allowed to call teh winner ");
        
        return winnerParty;
    }
}