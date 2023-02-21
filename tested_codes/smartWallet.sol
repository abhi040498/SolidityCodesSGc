//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

// What this Smart wallet project will do?

// Wallet has 1 owner.
// Recieve funds in any condition.
// Spend money on EOA (Externally Owned Account) and Contracts.
// Give allowance to other people for a certain amount of funds.
// Set a new owner with 3-out-of-5 guardian.

    contract MyCryptoWallet {

        address payable public owner;
        address payable public newowner;
        mapping (address => uint) public allowance;
        mapping (address => bool) public isAllowed;
        mapping (address => bool) public guardians;
        mapping (address => mapping (address => bool)) guardianVoted;
        uint8 guardianVoteCount;
        uint8 guardianVoteCountMax = 3;

// we havw called a constructor to store the owner in a variable.
       constructor() {
           owner = payable(msg.sender);
       }

// This function will add guardian to the wallet.
       function addGuardianToWallet (address _newProposedGuardian) public {
           require(msg.sender == owner, "You are not the Owner, Pease ask the owner of the wallet for adding guardian to wallet");
           guardians[_newProposedGuardian] = true;
       }

// voting of the guardian for proposing new owner.
        function votingGuardiansForNewOwner (address payable _newOwner) public {
            require(guardians[msg.sender], "Only guardians are allowed to vote, You are not one of them");
            require(guardianVoted[_newOwner][msg.sender] == false, "You are allowed to vote only once per new proposed owner");
            guardianVoted[_newOwner][msg.sender] = true;
            guardianVoteCount++;
        }

// This function will check proposal and set the new owner if required conditions matches.
        function setNewOwner( address payable _newOwner) public {
            require(msg.sender == owner, "You are not the Owner, Please ask the owner of the wallet for setting new owner");
            if(guardianVoteCount >= guardianVoteCountMax) {
                owner = _newOwner;
                guardianVoteCount = 0;
            }
        }

// This function sets allowance of certain funds to certain people.
        function setAllowanceForAnyone(address _allowedPerson, uint _allowingAmount) public {

            // require the owner to be the person who can set the allowance to anyone.
            require(owner == msg.sender);
            allowance[_allowedPerson] = _allowingAmount;
            // This condition checks and allows the owner to send amount > 0.
            if(_allowingAmount > 0) {
                isAllowed[_allowedPerson] = true;
                
            } 
           
        }

// This will allow to transfer fund to anyone. 
       function transferFund(address payable _recieverAddress, uint _amountToTransfer) public {
// only the wallet owner can initiate the transaction.
           if(msg.sender != owner) {
            //    if the sender is not the owner then he should be in allowed list of spender.
               require(isAllowed[msg.sender], "You are not allowed to send");
            //    If the person is in allowed category then he should transfer <= allowed amount.
               require(_amountToTransfer  <= allowance[msg.sender], "You are transfering more than allowed amount");
               _recieverAddress.transfer(_amountToTransfer);
               allowance[_recieverAddress] -= _amountToTransfer;
               
           } else {
               
        //    _recieverAddress.transfer(_amountToTransfer);
        //    we can use transfer function but this will cost more gas so we use .call.value method
            (bool isTrxSuccess, ) = _recieverAddress.call{value: _amountToTransfer}("");
            require(isTrxSuccess, "The transfer was not successful");
           }
         
       }



// This will allow the smart contract to recieve funds. 
       receive() external payable {}

    }