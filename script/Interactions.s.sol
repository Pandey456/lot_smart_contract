//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {Script, console} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract CreateSubscriptionID is Script {
    function createSubscriptionusingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address cordinator = helperConfig.getConfig().vrfCoordinator;
        (uint256 subID, ) = createSubscriptionID(cordinator);
        return (subID, cordinator);
    }

    function createSubscriptionID(
        address cordinator
    ) public returns (uint256, address) {
        console.log("creating sub id for chain id", block.chainid);
        vm.startBroadcast();
        uint256 subID = VRFCoordinatorV2Mock(cordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Subscription id is ", subID);
        return (subID, cordinator);
    }

    function run() public {
        createSubscriptionusingConfig();
    }
}

contract fundSubscription {
    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address cordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionID = helperConfig.getConfig().subscriptionId;
    }

    function run() public {}
}
