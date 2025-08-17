// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {SimpleStorage} from "./SimpleStorage.sol";

contract SolidityFactory {
    // type visibility name
    // uint public favoriteNumber
    SimpleStorage public simpleStorage;

    function createSimpleStorageContract() public {
        simpleStorage = new SimpleStorage();  // new - solidity knows deploy contract 
    }
}