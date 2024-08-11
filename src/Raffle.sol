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
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title Lottery Smart Contract
 * @author Owanemi
 * @notice This contract is for creating a sample raffle
 * @dev Implements chainlink VRF 2.5
 */
contract Raffle {
    /* Errors */
    error Raffle__NotEnoughEth();
    error Raffle__NotEnoughTimePassed();

    /* State Variables */
    uint256 private constant ENTRANCE_FEE = 0.1 ether;
    // @dev how frequently our winner is going to be picked in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /* Events */
    event RaffleEntered(address indexed player, uint256 indexed amount);

    constructor(uint256 interval) {
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        /* For version <0.8.24 */
        // require(msg.value >= ENTRANCE_FEE, "not enought eth");

        /* For version 0.8.24 */
        if (msg.value < ENTRANCE_FEE) {
            revert Raffle__NotEnoughEth();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender, msg.value);

        /* For version 0.8.26 */

        //also less gas efficient and needs to compile with via-ir
        // require(msg.value >= ENTRANCE_FEE, NotEnoughEth());
    }

    function pickWinner() external view {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert Raffle__NotEnoughTimePassed();
        }
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    }

    // i_entrance fee is stored on state so view function makes sense
    // however if entrance fee was a constant, pure function makes sense cos its not stored on state but embedded into bytecode
    // also if it was a regular state variable view would be used cos its stored in state

    /**
     * Getter functions
     */
    function getEntranceFee() external pure returns (uint256) {
        return ENTRANCE_FEE;
    }
}
