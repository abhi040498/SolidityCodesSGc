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


import "@openzeppelin/contracts/utils/Strings.sol";


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
        uint personRegDate;
    }
   struct Party {
       string partyName;
       string partyCity;
       string partySymbol;
       string partyID;
       uint partyRegDate;    
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
   string public votesCountToParty;
   mapping (address => uint) hasMaxVote;
   address private winnerParty;
   uint8 public partyCount;
   uint8 public personCount;
   uint public electionVotingDate;
   uint currentDate;
//    uint personRegistrationDate;
    

   constructor () {
       owner = msg.sender;
   }
   
//    Get the date and convert it to the timestamp.
    function getTimestamp(uint16 year, uint8 month, uint8 day) internal  pure returns (uint256) {
    
        uint256 timestamp = 0;

        // Calculate the number of seconds in each month up to the given month
        for (uint8 i = 1; i < month; i++) {
            if (i == 2 && isLeapYear(year)) {
                timestamp += 29 days;
            } else {
                timestamp += daysInMonth(i, year) * 1 days;
            }
        }

        // Add the number of seconds in the given day
        timestamp += (day - 1) * 1 days;

        // Add the number of seconds in each year up to the given year
        for (uint16 i = 1970; i < year; i++) {
            timestamp += isLeapYear(i) ? 366 days : 365 days;
        }

        return timestamp;
    }

// Also check if the year is a leap year or not
    function isLeapYear(uint16 year) private pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        } else if (year % 100 != 0) {
            return true;
        } else if (year % 400 != 0) {
            return false;
        } else {
            return true;
        }
    }
// counts all the days in the month
    function daysInMonth(uint8 month, uint16 year) private pure returns (uint8) {
        if (month == 2) {
            return isLeapYear(year) ? 29 : 28;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        } else {
            return 31;
        }
    }

// This will return the current date. (useful when registering person/ party or checking electionDate).
     function getCurrentDate() private returns (uint256) {
        uint256 secondsSinceMidnight = block.timestamp % 86400; // 86400 seconds in a day
        currentDate = block.timestamp - secondsSinceMidnight;
        return currentDate;
    }



// Checking how many votes, party has recieved.
   function checkVotesToParty(address _PartyAddressToCheckVotes) public returns (string memory) {

       uint beforeDecimal = votesToParty[_PartyAddressToCheckVotes] / 10;
       uint afterDecimal = votesToParty[_PartyAddressToCheckVotes] % 10;
       votesCountToParty = string(abi.encodePacked(Strings.toString(beforeDecimal), '.', Strings.toString(afterDecimal)));
       return votesCountToParty;
   }

// Registering the person with all details.
   function registerPerson (string memory _personName, string memory _personCity, uint8  _personAge, string memory _personGender, string memory _personQualification, string memory _personID) public {
       require(personHasRegistered[msg.sender] != true, "You have already registered, no need to register for 2nd time");
       require(partyHasRegistered[msg.sender] !=true , "You cannot register as a person, you are an individual party");
       require(block.timestamp < electionVotingDate, "You cannot register ont the election date! you are late for this election");
       individialPerson[msg.sender].personName = _personName;
       individialPerson[msg.sender].personCity = _personCity;
       individialPerson[msg.sender].personAge = _personAge;
       individialPerson[msg.sender].personGender = _personGender;
       individialPerson[msg.sender].personQualification = _personQualification;
       individialPerson[msg.sender].personID = _personID;
       personHasRegistered[msg.sender] = true;
       registeredPersonList[personCount] = msg.sender;
       personCount++;
       individialPerson[msg.sender].personRegDate = getCurrentDate();
       assigningVotePowertoVoter();
   }

// Registering the party with all details.
    function registerParty (string memory _partyName, string memory _partyCity, string memory _partySymbol, string memory _partyID) public {
        require(personHasRegistered[msg.sender] !=true , "You cannot register as a party, you are an individual person");
        require(partyHasRegistered[msg.sender] != true, "You have already registered, no need to register for 2nd time");
        require(block.timestamp < electionVotingDate, "You cannot register ont the election date! you are late for this election");
        individialParty[msg.sender].partyName = _partyName;
        individialParty[msg.sender].partyCity = _partyCity;
        individialParty[msg.sender].partySymbol = _partySymbol;
        individialParty[msg.sender].partyID = _partyID;
        partyHasRegistered[msg.sender] = true;
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
    function setVotingDateOfElection (uint16 _year, uint8 _month, uint8 _day) public returns (uint )  {
        require(msg.sender == owner, "Only the owner of the contract can set the election voting date");
        electionVotingDate = getTimestamp(_year, _month, _day);
        return electionVotingDate;
    }
 
// function to caste Vote.
    function casteVote (address _partyAddress) public {
        require(electionVotingDate == getCurrentDate(), "Today is not the election, Please come on election date to cast your vote");
        require(partyHasRegistered[_partyAddress], "This is not a valid party");
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
        require(msg.sender == owner, "You are not the owner, Only the owner is allowed to call the winner ");
        
        return winnerParty;
    }
}