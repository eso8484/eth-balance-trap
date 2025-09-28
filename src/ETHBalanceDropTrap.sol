// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ETHBalanceDropTrap
 * @dev Monitors a wallet's native ETH balance and triggers when it drops significantly
 * Perfect for HOODI testnet - simple, reliable, and easy to test!
 */
contract ETHBalanceDropTrap {
    // The wallet address to monitor
    address public immutable monitoredWallet;
    
    // Threshold: triggers when balance drops by this percentage (in basis points)
    // 500 = 5%, 1000 = 10%, 2000 = 20%
    uint256 public immutable dropThreshold;
    
    // Minimum balance required to trigger (prevents false alarms on dust)
    // Set to 0.01 ETH minimum to avoid gas fee noise
    uint256 public immutable minBalance;

    event TrapDeployed(address indexed wallet, uint256 threshold, uint256 minBalance);

    constructor(
        address _monitoredWallet, 
        uint256 _dropThreshold,
        uint256 _minBalance
    ) {
        monitoredWallet = _monitoredWallet;
        dropThreshold = _dropThreshold;
        minBalance = _minBalance;
        
        emit TrapDeployed(_monitoredWallet, _dropThreshold, _minBalance);
    }

    /**
     * @dev Collects the current ETH balance of the monitored wallet
     * Called by Drosera operators every block
     * @return The current ETH balance in wei
     */
    function collect() external view returns (uint256) {
        return monitoredWallet.balance;
    }

    /**
     * @dev Checks if there's an incident based on balance history
     * @param data Array of previous balance data from collect()
     * @return true if incident detected (significant balance drop), false otherwise
     */
    function shouldRespond(uint256[] calldata data) external view returns (bool) {
        // Need at least 2 data points to compare
        if (data.length < 2) {
            return false;
        }

        uint256 currentBalance = data[data.length - 1];  // Latest balance
        uint256 previousBalance = data[data.length - 2]; // Previous block balance
        
        // Skip if previous balance is below minimum threshold
        if (previousBalance < minBalance) {
            return false;
        }
        
        // Skip if previous balance was zero (avoid division by zero)
        if (previousBalance == 0) {
            return false;
        }
        
        // Calculate percentage drop
        if (currentBalance >= previousBalance) {
            return false; // No drop occurred
        }
        
        uint256 balanceDrop = previousBalance - currentBalance;
        uint256 percentageDrop = (balanceDrop * 10000) / previousBalance; // In basis points
        
        // Trigger if drop exceeds threshold
        return percentageDrop >= dropThreshold;
    }
    
    /**
     * @dev View function to help with testing and debugging
     * Returns current balance and calculates what drop would trigger the trap
     */
    function getMonitoringInfo() external view returns (
        uint256 currentBalance,
        uint256 triggerThreshold,
        uint256 minimumBalance,
        bool isAboveMinimum
    ) {
        currentBalance = monitoredWallet.balance;
        triggerThreshold = dropThreshold;
        minimumBalance = minBalance;
        isAboveMinimum = currentBalance >= minBalance;
    }
    
    /**
     * @dev Calculate what the new balance would need to be to trigger the trap
     * @param currentBalance Current balance to calculate from
     * @return The balance threshold that would trigger an alert
     */
    function calculateTriggerBalance(uint256 currentBalance) external view returns (uint256) {
        if (currentBalance < minBalance) {
            return 0;
        }
        
        uint256 dropAmount = (currentBalance * dropThreshold) / 10000;
        return currentBalance - dropAmount;
    }
}
