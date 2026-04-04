// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
    Raffle public raffle;

    function run() external {
        vm.startBroadcast();
        raffle = new Raffle(
            0.01 ether,
            30,
            0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625, // Sepolia VRF Coordinator
            0, // subId
            0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c, // gasLane
            500000
        );

        vm.stopBroadcast();
    }
}
