// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe {

    uint256 public minimumUsd = 5; 

    function fund() public payable{
        require(msg.value >= minimumUsd, "didn't send enough ETH");  // 1e18 = 1ETH = 1* 10^18 
    }



    //function withdraw() public {}

    function getPrice() public {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306. (ETH/USD)
        // ABI

    }
    function getConversionRate() public {}

    function getVersion() public view returns (uint256) {
        
    }
}