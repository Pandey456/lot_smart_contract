//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;
    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    uint256 subscriptionId;
    bytes32 gasLane;
    uint32 callbackGasLimit;
    address public Player = makeAddr("Player1");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;
    /* events */
    event RaffleEntered(address indexed player);
    event RaffleWinner(address indexed winner);

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        subscriptionId = config.subscriptionId;
        gasLane = config.gasLane;
        callbackGasLimit = config.callbackGasLimit;
        vm.deal(Player, STARTING_PLAYER_BALANCE);
    }

    function testRaffleStateStartswithOpen() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleEntryRevertwithoutFee() public {
        vm.prank(Player);
        vm.expectRevert(Raffle.Raffle__sendMoreEthTOEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleEntersPlayerToRecord() public {
        vm.prank(Player);
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded = raffle.getPlayerAddress(0);
        assert(playerRecorded == address(Player));
    }

    function testEventsEmitted() public {
        vm.prank(Player);
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEntered(Player);
        raffle.enterRaffle{value: entranceFee}();
    }
}
