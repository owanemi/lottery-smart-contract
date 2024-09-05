// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    address public PLAYER = makeAddr("Owanemi");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;
    uint256 public constant ENTRANCE_FEE = 0.1 ether;

    event RaffleEntered(address indexed player, uint256 indexed amount);
    event WinnerPicked(address indexed winner);

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployRaffle();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;
        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    function testRaffleStartsInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    /*//////////////////////////////////////////////////////////////
                              ENTER RAFFLE
    //////////////////////////////////////////////////////////////*/

    function testRaffleRevertsWhenEntranceFeeisNotEnough() public {
        // Arrange
        vm.prank(PLAYER);
        // Act/Assert
        vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);
        raffle.enterRaffle();
        // assert(raffle.ENTRANCE_FEE > )
    }

    function testRaffleUpdatesPlayersWhenTheyEnter() public {
        // Arrange
        vm.prank(PLAYER);
        console.log(PLAYER);
        // Act
        raffle.enterRaffle{value: ENTRANCE_FEE}();
        // Assert
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
        console.log(playerRecorded);
    }

    function testEnteringRaffleEmitsEvent() public {
        // arrange
        vm.prank(PLAYER);
        // act
        vm.expectEmit(true, true, false, false, address(raffle));
        emit RaffleEntered(PLAYER, ENTRANCE_FEE);
        // assert
        raffle.enterRaffle{value: ENTRANCE_FEE}();
    }

    // function testRejectNewPlayerWhileRaffleCalculating() public {
    //     // arrange
    //     vm.prank(PLAYER);
    //     raffle.enterRaffle{value: ENTRANCE_FEE}();
    //     vm.warp(block.timestamp + interval + 1);
    //     vm.roll(block.number + 1);
    //     raffle.performUpKeep("");

    //     // act/assert
    //     vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
    //     vm.prank(PLAYER);
    //     raffle.enterRaffle{value: ENTRANCE_FEE}();
    // }
}
