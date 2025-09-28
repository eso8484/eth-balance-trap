// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ETHBalanceAlertLogger
 * @dev Response contract that logs ETH balance drop alerts from Drosera traps
 */
contract ETHBalanceAlertLogger {
    
    struct AlertLog {
        address monitoredWallet;
        uint256 previousBalance;
        uint256 currentBalance;
        uint256 dropPercentage;
        uint256 timestamp;
        uint256 blockNumber;
        string message;
    }
    
    AlertLog[] public alerts;
    mapping(address => uint256) public alertCountByWallet;
    
    event ETHDropAlert(
        address indexed monitoredWallet,
        uint256 previousBalance,
        uint256 currentBalance,
        uint256 dropPercentage,
        string message,
        uint256 indexed alertId
    );
    
    /**
     * @dev Called by Drosera when ETH balance drop is detected
     * @param wallet The wallet that had a balance drop
     * @param previousBalance Previous block balance
     * @param currentBalance Current block balance  
     * @param message Custom alert message
     */
    function logETHDropAlert(
        address wallet,
        uint256 previousBalance,
        uint256 currentBalance,
        string calldata message
    ) external {
        
        // Calculate drop percentage
        uint256 dropPercentage = 0;
        if (previousBalance > 0 && currentBalance < previousBalance) {
            uint256 drop = previousBalance - currentBalance;
            dropPercentage = (drop * 10000) / previousBalance; // basis points
        }
        
        // Create alert log
        AlertLog memory newAlert = AlertLog({
            monitoredWallet: wallet,
            previousBalance: previousBalance,
            currentBalance: currentBalance,
            dropPercentage: dropPercentage,
            timestamp: block.timestamp,
            blockNumber: block.number,
            message: message
        });
        
        alerts.push(newAlert);
        alertCountByWallet[wallet]++;
        
        emit ETHDropAlert(
            wallet,
            previousBalance,
            currentBalance,
            dropPercentage,
            message,
            alerts.length - 1
        );
    }
    
    /**
     * @dev Get total number of alerts
     */
    function getAlertCount() external view returns (uint256) {
        return alerts.length;
    }
    
    /**
     * @dev Get latest alert
     */
    function getLatestAlert() external view returns (AlertLog memory) {
        require(alerts.length > 0, "No alerts yet");
        return alerts[alerts.length - 1];
    }
}
