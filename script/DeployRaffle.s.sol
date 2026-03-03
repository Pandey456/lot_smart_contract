// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
    Raffle public raffle;

    function run() external {
        vm.startBroadcast();
        raffle = new Raffle();

        vm.stopBroadcast();
    }
}
