//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract Fund{
    using PriceConverter for uint256;

    uint256 public minmUSD = 5;
    mapping(address => uint256 amountFunded) public addressToAmountFunded;    

    function fund() public payable{
        require(msg.value.getConversionRate() >= minmUSD, "Enough ETH was not sent!");
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // function withdraw() public{}
}