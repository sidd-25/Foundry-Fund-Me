// SPDX-License-Identifier: MIT

/*
__________________________________________________________________________________________

📄 HelperConfig.sol

🧠 PURPOSE:
    This contract helps us dynamically select or deploy the correct price feed address 
    depending on the network we're currently working on (Sepolia, Mainnet, or Anvil local chain).
    
    It makes our codebase chain-agnostic and easily testable on local and live environments.

__________________________________________________________________________________________

🧩 HOW IT WORKS:

1. The contract defines a `NetworkConfig` struct to group config-related parameters 
   (currently just `PriceFeeds`, but scalable for more like VRFCoordinator, etc).

2. On contract deployment (via constructor), it checks the current `block.chainid` to 
   determine which network we're working on:

    - If it's Sepolia (`chainid == 11155111`) → uses a hardcoded known PriceFeed address.
    - If it's Ethereum Mainnet (`chainid == 1`) → uses the real Mainnet PriceFeed address.
    - If it's local (Anvil/Hardhat with `chainid == 31337`) → deploys a mock price feed on-the-fly.

3. For Anvil (local testing):
   - First checks if a mock price feed has already been deployed by checking if `activeNetworkConfig.PriceFeeds` is non-zero.
   - If yes → returns the already deployed mock config.
   - If not → uses `vm.startBroadcast()` and `vm.stopBroadcast()` to deploy a `MockV3Aggregator` mock price feed.
   - Constants `DECIMALS` and `INITIAL_PRICE` are used to configure the mock.
   - The new mock address is returned and stored.

4. The chosen config is stored in the public variable `activeNetworkConfig`, 
   so that other scripts or contracts can easily access the right price feed address.

__________________________________________________________________________________________

✅ WHY THIS STRUCTURE IS USEFUL:

- Abstracts network-specific logic in one place.
- Cleanly separates config for each network.
- Easy to scale — just add more fields to the struct and update the 3 helper functions.
- Ensures mock deployment is automatic in local testing environments.
- Maintains compatibility with Foundry scripting tools using `vm`.

__________________________________________________________________________________________

🔧 Depends On:
- `MockV3Aggregator.sol` (used to create mock price feed)
- `forge-std/Script.sol` (for `vm` scripting utilities)
__________________________________________________________________________________________
*/


pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    
    // if on local chain (anvil, hardhat) we deploy mocks,
    // othwerwise we grab existing address from the live network.

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
            activeNetworkConfig = getorCreateAnvilNetworkConfig();
        }
    }

    function getSepoliaNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({PriceFeeds: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getEthereumMainnetNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({PriceFeeds: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649});
    }

    function getorCreateAnvilNetworkConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.PriceFeeds != address(0)) {
            return activeNetworkConfig;
        }

        // a function can't be pure with vm keyword
        // 1. Deploy the mocks on anvil
        // 2. retutn the address of the mocks on anvil

        // //1
        // vm.startBroadcast();
        // MockV3Aggregator mockV3AggregatorPriceFeeds = new MockV3Aggregator(8, 2000e8);
        // vm.stopBroadcast();

        //Use Magic Numbers instead
        vm.startBroadcast();
        MockV3Aggregator mockV3AggregatorPriceFeeds = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        //2
        return NetworkConfig({PriceFeeds: address(mockV3AggregatorPriceFeeds)});

    }

}
