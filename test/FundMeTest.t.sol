//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testDemo() public view {
        // console.log(fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testPriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }
}
