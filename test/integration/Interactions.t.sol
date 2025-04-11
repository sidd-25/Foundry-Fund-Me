// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract Interactions is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_ETH = 0.1 ether;
    uint256 constant ACCOUNT_BALANCE = 100 ether;

    function setUp () public {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, ACCOUNT_BALANCE);
    }

    function testUserCanFundViaInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log("FundMe Owner: ", fundMe.getOwner());
        console.log("Withdraw caller: ", msg.sender);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        console.log("Withdraw caller: ", msg.sender);

        assert(address(fundMe).balance == 0);

    }


}