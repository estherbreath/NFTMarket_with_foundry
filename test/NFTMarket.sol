// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NFTMarket} from "./NFTMarket";
import "forge-std/Vm.sol";


contract NFTMarket  is Test{
    NFTMarket public _NFTMarket;

    vm.startPrank();
     function setUp() public {
        _NFTMarket = new NFTMarket();
        _NFTMarket.createOrder();
    }
}

