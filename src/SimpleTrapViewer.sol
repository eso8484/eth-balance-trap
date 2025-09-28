// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ETHBalanceAlertLogger.sol";

/**
 * @title SimpleTrapViewer
 * @dev Easy-to-read interface for viewing trap results - perfect for screenshots!
 */
contract SimpleTrapViewer {
    ETHBalanceAlertLogger public immutable logger;
    
    constructor(address _logger) {
        logger = ETHBalanceAlertLogger(_logger);
    }
    
    /**
     * @dev Get total alert count and status - great for screenshots
     */
    function getTrapStats() external view returns (
        uint256 totalAlerts,
        string memory status
    ) {
        totalAlerts = logger.getAlertCount();
        
        if (totalAlerts == 0) {
            status = "NO ALERTS YET - WAITING FOR FIRST TRIGGER";
        } else {
            status = "ACTIVE - ALERTS DETECTED";
        }
    }
    
    /**
     * @dev Get alert count for a specific wallet
     */
    function getWalletAlertCount(address wallet) external view returns (uint256) {
        return logger.alertCountByWallet(wallet);
    }
    
    /**
     * @dev Check if trap has any alerts
     */
    function hasAlerts() external view returns (bool) {
        return logger.getAlertCount() > 0;
    }
    
    /**
     * @dev Get basic alert info by ID - returns individual fields
     */
    function getAlertBasics(uint256 alertId) external view returns (
        address wallet,
        uint256 prevBalance,
        uint256 currBalance,
        uint256 dropPercent,
        uint256 blockNum
    ) {
        // Access struct fields individually to avoid struct access issues
        (wallet, prevBalance, currBalance, dropPercent, , blockNum, ) = logger.alerts(alertId);
    }
    
    /**
     * @dev Get formatted balance strings for display
     */
    function getBalanceStrings(uint256 weiAmount) external pure returns (
        string memory ethAmount,
        string memory weiAmount_str
    ) {
        uint256 eth = weiAmount / 1e18;
        uint256 decimals = (weiAmount % 1e18) / 1e15; // 3 decimal places
        
        ethAmount = string(abi.encodePacked(
            _uintToString(eth), ".", _uintToString(decimals), " ETH"
        ));
        weiAmount_str = string(abi.encodePacked(_uintToString(weiAmount), " wei"));
    }
    
    /**
     * @dev Get drop percentage as readable string
     */
    function getDropPercentString(uint256 basisPoints) external pure returns (string memory) {
        uint256 percent = basisPoints / 100;
        uint256 remainder = basisPoints % 100;
        
        if (remainder == 0) {
            return string(abi.encodePacked(_uintToString(percent), "%"));
        } else {
            return string(abi.encodePacked(_uintToString(percent), ".", _uintToString(remainder), "%"));
        }
    }
    
    // Helper function for uint to string conversion
    function _uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
