// SPDX-License-Identifier:MIT
pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "src/Raffle.sol";

contract DeployRaffle is Script{

    function deployRaffle() external returns (Raffle){
        vm.startBroadcast();
        Raffle raffle = new Raffle();
        vm.stopBroadcast();
        return raffle;
    }

    function run() external returns (Raffle){
        return deployRaffle();
    }
}