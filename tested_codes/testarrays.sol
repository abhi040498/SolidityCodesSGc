// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract TestArray {
    // This [] with no value says it is a dynamic array.
    uint[] public myArray;

    // Pushes the data to the array.
    function Test() public {
        myArray.push(10);
        myArray.push(20);
        myArray.push(10);

    }
    // /Gets the data of the array. 
    function getMyArray() public view returns (uint []) {
        return myArray;
    }

    // Gets the length of the array.
    function getArrayLength() public view returns (uint) {
        return myArray.length;
    }

    // Gets the 1st element of the array.
    function getFirstElement() public view returns (uint) {
        return myArray[0];
    }

    // Important point to note
            // This [] with no value says it is a dynamic array.
            string[] public myArray;
            // since strings are treated as a datatype rather it is treated as array.
            // Pushing the data to the array will not execute. this will throw an error
            // UnimplementedFeatureError: Nested dynamic arrays not implemented here.

            function Test() public {
                myArray.push('testingstring');
            

            }
            // /Gets the data of the array. 
            function getArray() public view returns (string []) {
                return myArray;
            }

} 