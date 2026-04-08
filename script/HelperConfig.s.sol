//SPDX-License-Identifier:MIT
pragma solidity 0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

abstract contract codeConstant {
    uint256 constant SEPOLIA_ETH_CHAIN_ID = 11155111;
    uint256 constant LOCAL_CHAIN_ID = 31337;
    //uint96 _baseFee, uint96 _gasPriceLink
    uint96 constant MOCK_BASE_FEE = 0.25 ether;
    uint96 constant MOCK_GAS_PRICE_LINK = 1e9;
}

contract HelperConfig is Script, codeConstant {
    error HelperConfig__InvalidChainId();
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        uint256 subscriptionId;
        bytes32 gasLane;
        uint32 callbackGasLimit;
    }
    NetworkConfig public localnetworkConfig;
    mapping(uint256 chainID => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[SEPOLIA_ETH_CHAIN_ID] = getSepoliaETHconfig();
    }

    function getConfigByChainId(
        uint256 chainId
    ) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].vrfCoordinator != address(0)) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getSepoliaETHconfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625, // Sepolia VRF Coordinator
                subscriptionId: 0, // subId
                gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c, // gasLane
                callbackGasLimit: 500000
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (localnetworkConfig.vrfCoordinator != address(0)) {
            return localnetworkConfig;
        }
        // else - mock
        VRFCoordinatorV2Mock mock = new VRFCoordinatorV2Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK
        );
        localnetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(mock),
            subscriptionId: 0, // subId
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c, // gasLane
            callbackGasLimit: 500000
        });
    }
}
