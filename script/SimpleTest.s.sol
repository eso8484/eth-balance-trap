// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/SimpleTrapViewer.sol";

contract SimpleTest is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy simple viewer
        SimpleTrapViewer viewer = new SimpleTrapViewer(0x12a8fD9771C11caF7B66fBc6054C12BC544096D2);

        console.log("DEPLOYMENT COMPLETE!");
        console.log("====================");
        console.log("SimpleTrapViewer deployed to:", address(viewer));
        console.log("Logger address:", 0x12a8fD9771C11caF7B66fBc6054C12BC544096D2);
        console.log("");
        console.log("SCREENSHOT COMMANDS:");
        console.log("====================");
        console.log("1. Check trap status:");
        console.log("   cast call --rpc-url hoodi", address(viewer), "getTrapStats()");
        console.log("");
        console.log("2. Check wallet alert count:");
        console.log("   cast call --rpc-url hoodi", address(viewer));
        console.log("   \"getWalletAlertCount(address)\" 0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb");

        vm.stopBroadcast();
    }
}
