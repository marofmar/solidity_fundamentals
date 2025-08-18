// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe {

    uint256 public minimumUsd = 5 * 1e18; 

    function fund() public payable{
        require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH");  // 1e18 = 1ETH = 1* 10^18 
    }



    //function withdraw() public {}

    function getPrice() public view returns(uint256) {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306 (ETH/USD)
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 5000.00000000
        return uint256(price * 1e10);

    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // multiply first
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256) {
        
    }
}