// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelperConfigNoStruct {

    address public PriceFeeds;
    address public VRFCoordinator;
    uint64 public SubscriptionId;
    uint256 public EntranceFee;
    uint32 public CallbackGasLimit;

    constructor() {
        if (block.chainid == 11155111) {
            setSepoliaConfig();
        } else if (block.chainid == 1) {
            setEthereumMainnetConfig();
        } else if (block.chainid == 31337) {
            setAnvilConfig();
        }
    }

    function setSepoliaConfig() internal {
        PriceFeeds = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        VRFCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
        SubscriptionId = 1234;
        EntranceFee = 0.01 ether;
        CallbackGasLimit = 500000;
    }

    function setEthereumMainnetConfig() internal {
        PriceFeeds = 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649;
        VRFCoordinator = 0xABCDEF1234567890ABCDEF1234567890ABCDEF12;
        SubscriptionId = 5678;
        EntranceFee = 0.02 ether;
        CallbackGasLimit = 600000;
    }

    function setAnvilConfig() internal {
        PriceFeeds = 0x0000000000000000000000000000000000000001;
        VRFCoordinator = 0x0000000000000000000000000000000000000002;
        SubscriptionId = 9999;
        EntranceFee = 0.001 ether;
        CallbackGasLimit = 300000;
    }
}
