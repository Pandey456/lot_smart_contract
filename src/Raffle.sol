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

/**
 * @title A lottery contract
 * @author Adarsh
 * @notice THis contract will create simple raffle contract
 */

contract Raffle {
    /** errors */
    error Raffle__senMoreEthTOEnterRaffle();

    /** Variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /* events */
    event RaffleEntered(address player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
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

    function pickWinner() public {}

    /** Getter function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
