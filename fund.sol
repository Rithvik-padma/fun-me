//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Fund{

    uint public minmUSD = 5;
    function fund() public payable{
        require(msg.value > minmUSD, "Enough ETH was not sent!");

    }

    function getPrice() public view returns(uint256){
        //Address: 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22
        return AggregatorV3Interface(0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22).version();
    }

    function getConversionRate() public{}

    function withdraw() public{}
}