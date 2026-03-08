// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A lottery contract
 * @author Adarsh
 * @notice THis contract will create simple raffle contract
 */

contract Raffle is VRFConsumerBaseV2Plus {
    /** errors */
    error Raffle__senMoreEthTOEnterRaffle();

    /** Variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    //@dev - thie after which the lottery will pick a winner (in seconds)
    uint256 immutable i_interval;
    uint256 private s_lastTimeStamp;

    /* events */
    event RaffleEntered(address player);

    constructor(
        uint256 _entranceFee,
        uint256 _interval,
        address _vrfCoordinator
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) {
        i_entranceFee = _entranceFee;
        i_interval = _interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee,"not enough ETH to send"); --> this will require more gas
        // as it has to store this string "not enough ETH to send", so we will use revert
        if (msg.value < i_entranceFee) {
            revert Raffle__senMoreEthTOEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() public {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert();
        }
        VRFV2PlusClient.RandomWordsRequest request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    /** Getter function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
