//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract Fund{
    using PriceConverter for uint256;

    uint256 public minmUSD = 5;
    address[] public funders; 
    mapping(address => uint256 amountFunded) public addressToAmountFunded;    
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= minmUSD, "Enough ETH was not sent!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public{
        require(owner == msg.sender, "Must be owner!");
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool withdrawSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(withdrawSuccess, "Withdraw failed!");
    }
}