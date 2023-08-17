//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract Fund{
    using PriceConverter for uint256;

    uint256 public constant minmUSD = 5e18;
    address[] public funders; 
    mapping(address => uint256 amountFunded) public addressToAmountFunded;    
    address public immutable owner;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= minmUSD, "Enough ETH was not sent!");
        if(addressToAmountFunded[msg.sender] == 0) funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool withdrawSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(withdrawSuccess, "Withdraw failed!");
    }

    modifier onlyOwner{
        require(owner == msg.sender, "Must be owner!");
        _;
    }
}