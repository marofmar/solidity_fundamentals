// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;  // Solidity version

contract SimpleStorage {
    // favorite number will be initialized to 0 if no value is given
    uint256 myFavoriteNumber;

    //uint256[] listOfFavoriteNumbers;
    struct Person {
        uint256 favoriteNumber;
        string name;
    }
    // dynamic array
    Person[] public listOfPeople;  // []

    // chelsea -> 232
    mapping(string => uint256) public nameToFavoriteNumber;



    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    } 
    
    function retreive() public view returns(uint256) {
        return myFavoriteNumber;
    }

    // calldata, memory, storage 
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    
}
