// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    //  this function will allow the player to enter the game.
    // It will check few conditions like the player joining the game also sends some eth as fees. 
    function enters() public payable {
        require(msg.value >= 1 ether);   // checks if the ether send is above the desired amount.
        players.push(msg.sender);       // once validated the player is allowed to in
    }

    function random() private view returns (uint) {
        // here we take current block difficulty, current time, adn address of the player and we feed them into the sha3 algorithm.
        // This will return hexadecimal so we need tpo convert them to the uint for that we use uint()
        //  sha3 and keccak256 are both same things.
        return uint(keccak256(block.difficulty, now, players));
    
    }

    // Now we can use random() % players.length to generate winner. adn this will return a number between 0 and 1-player length.
    function pickWinner() public {
        // SInce we want that the manager should only call the winning function  we need to provide a condition
        require(msg.sender == manager);
        uint index = random() % players.length;
        // player[index] is the winner so we can transfer the amount to the winner. for this we use transfer function.
        // since we want to transfer the total balance of the contract to winner so we use this.balance 
        players[index].transfer(this.balance);

        // Once the game is over we need to free the array so that new set of plople can join the game and play it.
        // Here value in [x] will create a array of length x adn value of (y) will create an array with initial length y.
        players = new address[](0);
    }

    // When we want to perform any function that is to be used in multiple places we write a fucntion and at the end of the function body we write
    // _; This tells the function to execute all the code of the parent function from there. 

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // This function will return all the players in an array.  
    function getPlayers() public view  returns (address[]) {
        return players;
    }

}