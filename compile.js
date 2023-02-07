// compile code will go here

const path = require('path')
const fs = require('fs');  //File system Module ( to read the data from the file).
const solc = require('solc');  //solidity compiler.

//Constant that will directly point the Inbox.sol file.
const inboxPath= path.resolve(__dirname, 'contracts', 'Inbox.sol');   //dirname is a constant defined by node and always sets to current working directory.
//Read in the raw source code from the contract
const source = fs.readFileSync(inboxPath, 'utf8');

// solc.compile(source, 1); //passed is the source code and the number of contracts.
modules.exports = solc.compile(source, 1),contracts[':Inbox']; // to get access to the bytecode property in compile.js file and the interface which is ABI.




