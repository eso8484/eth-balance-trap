// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/ETHBalanceDropTrap.sol";
import "../src/ETHBalanceAlertLogger.sol";

contract DeployETHBalanceTrap is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the response contract first
        ETHBalanceAlertLogger responseContract = new ETHBalanceAlertLogger();
        console.log("Response Contract deployed to:", address(responseContract));

        // Deploy the trap contract
        ETHBalanceDropTrap trap = new ETHBalanceDropTrap(
            0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb, // Your wallet address
            1000, // 10% drop threshold
            10000000000000000 // 0.01 ETH minimum
        );
        console.log("ETH Balance Drop Trap deployed to:", address(trap));
        
        // Log current balance for verification
        console.log("Current balance of monitored wallet:", address(0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb).balance);
        
        // Calculate what balance would trigger the trap
        uint256 currentBalance = address(0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb).balance;
        uint256 triggerBalance = trap.calculateTriggerBalance(currentBalance);
        console.log("Balance needs to drop below:", triggerBalance, "wei to trigger");
        console.log("That's approximately:", triggerBalance / 1e18, "ETH");

        vm.stopBroadcast();
        
        // Output for drosera.toml
        console.log("\n=== UPDATE YOUR drosera.toml ===");
        console.log("response_contract =", vm.toString(address(responseContract)));
        console.log("address =", vm.toString(address(trap)));
    }
}
