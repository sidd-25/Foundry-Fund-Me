//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    // address public DeployFundMeKisnekiya = address(this);

    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        (address getEthToUsdPriceFeed) = helperConfig.activeNetworkConfig();
        
        vm.startBroadcast();
        FundMe fundMe = new FundMe(getEthToUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
