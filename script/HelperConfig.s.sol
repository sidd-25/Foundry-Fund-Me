// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract HelperConfig {

    struct NetworkConfig {
        address PriceFeeds;
    }

    NetworkConfig public activeNetworkConfig;

    constructor(){
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaNetworkConfig();
        } 
        else if (block.chainid == 1) {
            activeNetworkConfig = getEthereumMainnetNetworkConfig();
        }
        else if (block.chainid == 31337) {
            activeNetworkConfig = getAnvilNetworkConfig();
        }
    }

    function getSepoliaNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({PriceFeeds: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getEthereumMainnetNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({PriceFeeds: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649});
    }

    function getAnvilNetworkConfig() public pure returns (NetworkConfig memory) {
        
    }

}
