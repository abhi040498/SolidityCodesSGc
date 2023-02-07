// contract test code will go here
const assert = require('assert'); // used to make assertion to the tests.
const ganache = require('ganache-cli'); // servs as a local ethereum test network
const Web3 = require('web3'); //Used to create an instance of Web3 library.
const web3 = new Web3(ganache.provider());
const {interface, bytecode } = require('../compile');

let accounts;
let inbox;

beforeEach(async () => {
    // Get list of all accounts
    // For this we use Instance of the Web3 followed by the accountType and GetAccount function to get the accounts details.
    // Since Everything in web3 is Asynchronus It will return a promise. for this we write .then function to pass account details. 
    accounts = await web3.eth.getAccounts();
      

    //We will use one of those accounts to deploy the contract

    // The Contract here is a constructor function that allows to create a new contract or interact with the existing contract.
    // ABI is the intermediatery between js world and solidity world.
    // The contract needs js object so we parse the data present in JSON, produced by the compiler.
    inbox = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({data: bytecode, arguments: ['This is mapping to initialMessage']})         // tells contract that we want to deploy a new contract.
        .send({from: accounts[0], gas: '1000000'});                                         // This will send out a transaction for the contract creation. 

});

// This is for deploying the contract.
describe('Inbox', () => {
    it('Deploys a contract', () => {
       // console.log(inbox);           // Just for testing the code is working fine.
       // To know that the function kis successfully deployed. we test it with assetrtion. 
       // It will check whether the address is assigned or not.
       assert.ok(inbox.options.address);
    });

    // this is for verifying the contract. 
    it('Has a default Message', async () => {
        //  The message function is used to call the message from the construstor function.
        // call() function is used to customize the transaction that we are attempting to send out to the network.
        // We can specify whi is going to pay for this and how much gas is used.
        const message = await inbox.methods.message().call();
        // Now we call equal function to compare the messages.
        assert.equal(message, 'This is mapping to initialMessage');
    });

    // this is for updating the contract.
    it('Can change the messasge', async () => {
        //  This will update the message in the contract. 
        //  To do so we need to send a transaction for gas fees as this is causing the change in the contract.
        //  We dont have to verify that the updation as this will show failed upon failing.
        await inbox.methods.setMessage('Setting new message').send({from: accounts[0]});
        // just fo our debugging we can test whether the change was successful or not.
        const message = await inbox.methods.message().call();
        assert.equal(message, 'Setting new message');

    });
});

