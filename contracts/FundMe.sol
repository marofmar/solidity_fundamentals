// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

//import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns(uint256) {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306 (ETH/USD)
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 5000.00000000
        return uint256(price * 1e10);

    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // multiply first
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        //zksync sepolia eth/usd 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        return priceFeed.version();
    }
}

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 1 * 1e18; 

    address[] public funders;
    mapping(address funder =>uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable{
        
        require(msg.value.getConversionRate()>= MINIMUM_USD, "didn't send enough ETH");  // 1e18 = 1ETH = 1* 10^18 
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
        require(msg.sender == i_owner, "Sender is not owner!");
        _;
    }


}