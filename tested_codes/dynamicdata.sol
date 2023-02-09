// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract DataLocations {
    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    function examples() external {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        MyStruct storage myStructs = myStructs[msg.sender];
        
    }
}