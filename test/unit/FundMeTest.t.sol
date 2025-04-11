//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");
    uint256 constant ACCOUNT_BALANCE = 100 ether;
    uint256 constant SEND_ETH = 0.1 ether;
    uint256 constant GAS_PRICE = 0.00000001 ether;
    // address DEPLOY_FUNDME_ADDRESS;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // DEPLOY_FUNDME_ADDRESS = deployFundMe.DeployFundMeKisnekiya();
        vm.deal(USER, ACCOUNT_BALANCE);
    }

    function testDemo() public view {
        // console.log(fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testPriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        // using cheatcodes in foundry
        // 1. vm.expectRevert(); hey the next line should revert 
        //    assert (Txn fails then revert)
        vm.expectRevert();
        fundMe.fund{value: 0}();   
    }

    function testFundUpdatesMapping() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETH}();
        // uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_ETH);

    }

    function testFundUpdatesFundersArray() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETH}();
        assertEq(fundMe.getFunder(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETH}();
        // console.log("Address of DeployFundMe contract:", DEPLOY_FUNDME_ADDRESS);
        // console.log("Address of FundMeTest contract:", address(this));
        // console.log("USER:", USER);
        // console.log("Owner of FundMe contract:", fundMe.getOwner());

        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public {

        // Arrange
        vm.prank(USER);
        fundMe.fund{value: SEND_ETH}();

        uint256 StartingOwnersBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;
        console.log("StartingOwnersBalance", StartingOwnersBalance);
        console.log("StartingFundMeBalance", StartingFundMeBalance);

        // Act
        uint256 gasStart = gasleft();
        console.log("Gas Start", gasStart);

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        console.log("Gas End", gasEnd);
        console.log("Gas price", GAS_PRICE);
        uint256 gasUsed = (gasStart - gasEnd) *  GAS_PRICE ;
        console.log("Gas Used", gasUsed);


        // Assert
        uint256 EndingOwnersBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        console.log("EndingOwnersBalance", EndingOwnersBalance);
        console.log("EndingFundMeBalance", EndingFundMeBalance);

        assertEq(StartingOwnersBalance + StartingFundMeBalance, EndingOwnersBalance);
        assertEq(0, EndingFundMeBalance);
    }

    modifier funded () {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETH}();
        _;
    }

    function testWithdrawWithMultipleFunder() public funded {
        
       uint160 numberOfFunders = 10;
       
       for (uint160 i = 1; i < numberOfFunders; i++) {
        // Always start with uint160 i = 1; said `Patrik`

           /* vm.prank - for address
              vm.deal - for funds
              together makes a group of funders 
            */
           // instead use hoax this do both combined
           hoax(address(i), SEND_ETH);
           fundMe.fund{value: SEND_ETH}();
       } 

        uint256 StartingOwnersBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;
        console.log("StartingOwnersBalance", StartingOwnersBalance);
        console.log("StartingFundMeBalance", StartingFundMeBalance);

        // vm.prank(fundMe.getOwner());
        // fundMe.withdraw();

        // the below one is commonly used instead of above
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 EndingOwnersBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        console.log("EndingOwnersBalance", EndingOwnersBalance);
        console.log("EndingFundMeBalance", EndingFundMeBalance);

        assertEq(StartingOwnersBalance + StartingFundMeBalance, fundMe.getOwner().balance);
        assertEq(0, address(fundMe).balance);
    }

    function testCheaperWithdrawWithMultipleFunder() public funded {
        
       uint160 numberOfFunders = 10;
       
       for (uint160 i = 1; i < numberOfFunders; i++) {
        // Always start with uint160 i = 1; said `Patrik`

           /* vm.prank - for address
              vm.deal - for funds
              together makes a group of funders 
            */
           // instead use hoax this do both combined
           hoax(address(i), SEND_ETH);
           fundMe.fund{value: SEND_ETH}();
       } 

        uint256 StartingOwnersBalance = fundMe.getOwner().balance;
        uint256 StartingFundMeBalance = address(fundMe).balance;
        console.log("StartingOwnersBalance", StartingOwnersBalance);
        console.log("StartingFundMeBalance", StartingFundMeBalance);

        // vm.prank(fundMe.getOwner());
        // fundMe.withdraw();

        // the below one is commonly used instead of above
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        uint256 EndingOwnersBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        console.log("EndingOwnersBalance", EndingOwnersBalance);
        console.log("EndingFundMeBalance", EndingFundMeBalance);

        assertEq(StartingOwnersBalance + StartingFundMeBalance, fundMe.getOwner().balance);
        assertEq(0, address(fundMe).balance);
    }

}
