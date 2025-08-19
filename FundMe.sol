// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {PriceConverter} from "./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5 * 1e18; 

    address[] public funders;
    mapping(address funder =>uint256 amountFunded) public addressToAmountFunded;

    address public owner;
    constructor() {
        owner = msg.sender;
    }

    function fund() public payable{
        
        require(msg.value.getConversionRate()>= minimumUsd, "didn't send enough ETH");  // 1e18 = 1ETH = 1* 10^18 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        // mapping addressToAmiountFunded[funder] = amountFunded
        for (uint256 funderIndex = 0; funderIndex<funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset array
        funders = new address[](0);

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }


}