//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract CreateSubscriptionID is Script {
    function createSubscriptionusingConfig() public {}

    function run() public {
        createSubscriptionusingConfig();
    }
}
