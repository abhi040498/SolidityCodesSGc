// contract test code will go here
const assert = require('assert'); // used to make assertion to the tests.
const ganache = require('ganache-cli'); // servs as a local ethereum test network
const Web3 = require('web3'); //Used to create an instance of web3 library.
const web3 = new Web3(ganache.provider());


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