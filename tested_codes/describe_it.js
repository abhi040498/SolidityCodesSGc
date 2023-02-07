// contract test code will go here
const assert = require('assert'); // used to make assertion to the tests.
const ganache = require('ganache-cli'); // servs as a local ethereum test network
const Web3 = require('web3'); //Used to create an instance of web3 library.
const web3 = new Web3(ganache.provider());
const {interface, bytecode } = require('../compile');


class Car {
    park() {
        return 'stopped';
    }
    drive() {
        return 'vroom';
    }

}
let car;
// If we have multiple times object creagted in our code then we can use beforeEach function.
beforeEach(() => {
    car = new Car();
});

//assert allows to make sure that one value is equal to other.
// Describe function in used to group tests.  
// it() function is used to execute the individual tests.

describe('Car', () => {
    it('Can park', () => {
        const car = new Car();
        assert.equal(car.park(), 'stoopped');
    });
    it('Can drive', () => {
        const car = new Car();
        assert.equal(car.drive(), 'vroom');
    });
});

it('testing park', () => {
    const car = new Car();
    assert.equal(car.park(), 'stopped');
});


//Getting Account details.

beforeEach(() => {
    // Get list of all accounts
    // For this we use Instance of the Web3 followed by the accountType and GetAccount function to get the accounts details.
    // Since Everything in web3 is Asynchronus It will return a promise. for this we write .then function to pass account details. 
    web3.eth.getAccounts()
        .then(fetchedAccounts => {
            console.log(fetchedAccounts); // this wil print the passed account details to fetAccount
    });

    //We will use one of those accounts to deploy the contract
});

describe('Inbox', () => {
    it('Deploys a contract', () => {});
});