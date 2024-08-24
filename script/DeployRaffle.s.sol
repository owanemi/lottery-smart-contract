// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployRaffle is Script {
    function run() external /*Raffle*/ {
        // return deployRaffle();
    }

    function deployRaffle() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getSepoliaConfig();

        if (config.subscriptionId == 0) {}

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.interval, config.vrfCoordinator, config.gasLane, config.subscriptionId, config.callbackGasLimit
        );
        vm.stopBroadcast();
        return (raffle, helperConfig);
    }
}
