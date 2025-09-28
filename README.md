# ETH Balance Drop Trap

A Drosera trap that monitors native ETH balance drops and triggers automated alerts when significant decreases are detected.

## 🎯 Overview

This trap monitors a specified wallet's native ETH balance every block and triggers when the balance drops by more than a configurable threshold percentage in a single block.

**Perfect for:**
- Personal wallet monitoring
- Treasury protection
- Automated incident response
- Large holder surveillance

## 🏗️ Architecture

### Core Components

1. **ETHBalanceDropTrap.sol** - Main trap contract
   - `collect()` - Gathers current ETH balance data
   - `shouldRespond()` - Analyzes balance history for significant drops

2. **ETHBalanceAlertLogger.sol** - Response contract
   - Logs detailed alert information
   - Emits searchable events
   - Maintains alert history

3. **drosera.toml** - Configuration for Drosera network

## 📊 Test Results

**Deployment:** HOODI Testnet (Chain ID: 560048)
- **Trap Contract:** `0x8E9E6ba7285d31a2404bEaeb6215A4bc9383B74C`
- **Response Contract:** `0x12a8fD9771C11caF7B66fBc6054C12BC544096D2`
- **Monitored Wallet:** `0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb`

**Live Test Results:**
- ✅ **Balance Drop Detected:** 57.17% (10.498 ETH → 4.495 ETH)
- ✅ **Alert Triggered:** Successfully logged in block 1303778
- ✅ **Event Emitted:** `ETHDropAlert` with complete data
- ✅ **Threshold Working:** 10% threshold correctly identified 57% drop

## ⚙️ Configuration

```solidity
constructor(
    address _monitoredWallet,    // Wallet to monitor
    uint256 _dropThreshold,      // Drop % in basis points (1000 = 10%)
    uint256 _minBalance          // Minimum balance to avoid gas fee noise
)
```

**Default Settings:**
- **Drop Threshold:** 1000 basis points (10%)
- **Minimum Balance:** 0.01 ETH (prevents gas fee false alarms)
- **Sample Size:** 5 blocks of history
- **Cooldown:** 10 blocks between triggers

## 🚀 Quick Start

### 1. Deploy the Trap

```bash
forge script script/DeployETHBalanceTrap.s.sol --rpc-url hoodi --broadcast
```

### 2. Update Configuration

Update `drosera.toml` with deployed contract addresses:

```toml
[traps.eth_balance_monitor]
address = "YOUR_TRAP_CONTRACT_ADDRESS"
response_contract = "YOUR_RESPONSE_CONTRACT_ADDRESS"
```

### 3. Test the Trap

```bash
# Send ETH to trigger (>10% of balance)
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  --to 0x000000000000000000000000000000000000dEaD \
  --value 2ether
```

### 4. Monitor Alerts

```bash
# Check for alert events
cast logs --rpc-url hoodi \
  --address YOUR_RESPONSE_CONTRACT_ADDRESS \
  --from-block latest
```

## 🧪 Testing & Verification

### Manual Testing Commands

```bash
# Check current balance
cast call --rpc-url hoodi TRAP_ADDRESS "collect()(uint256)"

# Test trap logic with historical data
cast call --rpc-url hoodi TRAP_ADDRESS \
  "shouldRespond(uint256[])" "[PREVIOUS_BALANCE,CURRENT_BALANCE]"

# Manually trigger alert
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  RESPONSE_ADDRESS \
  "logETHDropAlert(address,uint256,uint256,string)" \
  WALLET_ADDRESS PREV_BALANCE CURR_BALANCE "Test message"
```

## 📋 Event Schema

```solidity
event ETHDropAlert(
    address indexed monitoredWallet,  // Wallet that had balance drop
    uint256 previousBalance,          // Balance in previous block
    uint256 currentBalance,           // Current balance
    uint256 dropPercentage,           // Drop % in basis points
    string message,                   // Alert message
    uint256 indexed alertId           // Sequential alert ID
);
```

## 🛡️ Security Features

- **Minimum Balance Check:** Prevents gas fee noise
- **Zero Balance Protection:** Avoids division by zero
- **Percentage Threshold:** Configurable sensitivity
- **Cooldown Period:** Prevents spam alerts
- **Historical Analysis:** Uses multiple data points

## 📊 Analysis Capabilities

- **Rate of Change Analysis:** Detects rapid balance decreases
- **Threshold-Based Monitoring:** Configurable percentage triggers
- **Time-Series Data:** Historical balance tracking
- **Event Logging:** Complete audit trail

## 🔧 Advanced Configuration

### Custom Thresholds
```solidity
uint256 threshold = 500;   // 5% drop
uint256 threshold = 1000;  // 10% drop (default)
uint256 threshold = 2000;  // 20% drop
```

### Response Actions
The response contract can be customized to:
- Send notifications
- Pause contracts
- Transfer funds
- Call external APIs
- Trigger complex workflows

## 📈 Production Deployment

1. **Deploy on mainnet** with your production parameters
2. **Submit trap to Drosera** for operator review
3. **Register with operators** for 24/7 monitoring
4. **Configure alerts** for your preferred notification channels

## 🤝 Contributing

This trap is part of the Drosera examples repository. Contributions welcome!

---

**Built with Drosera Protocol** 🌿  
*Automated on-chain incident response*
