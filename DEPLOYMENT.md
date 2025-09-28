# Complete Deployment Guide

Comprehensive step-by-step instructions for deploying and testing the ETH Balance Drop Trap with screenshot documentation.

## 📋 Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed and updated
- Private key for deployment wallet (testnet recommended for first deployment)
- Testnet ETH for gas fees (HOODI testnet supported out-of-the-box)
- Basic understanding of command line operations

## 🚀 Phase 1: Project Setup

### 1.1 Clone and Initialize Project
```bash
# Create new directory and initialize Foundry project
mkdir eth-balance-drop-trap
cd eth-balance-drop-trap
forge init . --no-git
```
### 1.2 Install Dependencies
```bash
# Install OpenZeppelin contracts
forge install OpenZeppelin/openzeppelin-contracts --no-commit

# Verify installation
ls lib/
```
### 1.3 Configure Foundry
Create `foundry.toml` configuration:
```bash
cat > foundry.toml << 'EOF'
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/"
]

[rpc_endpoints]
hoodi = "https://ethereum-hoodi-rpc.publicnode.com"

[etherscan]
hoodi = { key = "YOUR_KEY", url = "https://explorer.hoodi.drosera.io/api" }
EOF
```

### 1.4 Set up Environment
```bash
# Create environment file (NEVER commit this!)
echo "PRIVATE_KEY=your_private_key_here" > .env

# Add to .gitignore
echo ".env" >> .gitignore
echo "broadcast/" >> .gitignore
echo "cache/" >> .gitignore
```

## 📄 Phase 2: Contract Creation

### 2.1 Create Source Files
Create the following files in `src/` directory:
- `ETHBalanceDropTrap.sol` - Main trap contract
- `ETHBalanceAlertLogger.sol` - Response/logging contract  
- `SimpleTrapViewer.sol` - Monitoring interface contract

### 2.2 Create Deployment Scripts
Create `script/DeployETHBalanceTrap.s.sol` and `script/SimpleTest.s.sol`

### 2.3 Compile Contracts
```bash
forge build
```
## 🏗️ Phase 3: Contract Deployment

### 3.1 Deploy Main Contracts
```bash
# Deploy trap and logger contracts
forge script script/DeployETHBalanceTrap.s.sol:DeployETHBalanceTrap --rpc-url hoodi --broadcast
```

**Record Contract Addresses:**
- Trap Contract: `_____________________`
- Logger Contract: `_____________________`
- Monitored Wallet: `_____________________`

### 3.2 Deploy Monitoring Interface
```bash
# Deploy viewer contract for easy monitoring
forge script script/SimpleTest.s.sol:SimpleTest --rpc-url hoodi --broadcast
```

**Record Viewer Address:** `_____________________`

## 🧪 Phase 4: Functionality Testing

### 4.1 Test Current Status
```bash
# Check trap statistics
cast call --rpc-url hoodi VIEWER_ADDRESS "getTrapStats()"
```

### 4.2 Test Balance Collection
```bash
# Test the collect() function
cast call --rpc-url hoodi TRAP_ADDRESS "collect()(uint256)"
```
### 4.3 Test Alert Count
```bash
# Check wallet-specific alert count
cast call --rpc-url hoodi VIEWER_ADDRESS \
  "getWalletAlertCount(address)" YOUR_WALLET_ADDRESS
```
### 4.4 Test Trap Logic
```bash
# Test shouldRespond with mock data (15% drop scenario)
cast call --rpc-url hoodi TRAP_ADDRESS \
  "shouldRespond(uint256[])" "[10000000000000000000,8500000000000000000]"
```

## 🚨 Phase 5: Alert System Testing

### 5.1 Manual Alert Test
```bash
# Create a manual test alert
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  LOGGER_ADDRESS \
  "logETHDropAlert(address,uint256,uint256,string)" \
  YOUR_WALLET_ADDRESS \
  10000000000000000000 \
  8500000000000000000 \
  "Testing - 15% Balance Drop Alert"
```

### 5.2 Verify Alert Logging
```bash
# Check updated trap statistics
cast call --rpc-url hoodi VIEWER_ADDRESS "getTrapStats()"
```

### 5.3 Check Alert Count
```bash
# Verify alert was logged
cast call --rpc-url hoodi VIEWER_ADDRESS \
  "getWalletAlertCount(address)" YOUR_WALLET_ADDRESS
```

### 5.4 View Alert Events
```bash
# Check blockchain events
cast logs --rpc-url hoodi --address LOGGER_ADDRESS --from-block latest
```

## ⚡ Phase 6: Real Transaction Testing

### 6.1 Check Pre-Transaction Balance
```bash
# Record current balance before test
cast balance YOUR_WALLET_ADDRESS --rpc-url hoodi
```

**Balance Before Test:** `_____________________`

### 6.2 Execute Real Transaction
```bash
# Send ETH to trigger actual balance drop (adjust amount as needed)
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  --to 0x000000000000000000000000000000000000dEaD \
  --value 2ether
```

### 6.3 Verify Balance Change
```bash
# Check new balance
cast balance YOUR_WALLET_ADDRESS --rpc-url hoodi

# Test collect function with new balance
cast call --rpc-url hoodi TRAP_ADDRESS "collect()(uint256)"
```

**Balance After Test:** `_____________________`

### 6.4 Test with Real Data
```bash
# Test shouldRespond with actual before/after balances
cast call --rpc-url hoodi TRAP_ADDRESS \
  "shouldRespond(uint256[])" "[BEFORE_BALANCE,AFTER_BALANCE]"
```


## 📊 Phase 7: Monitoring Verification

### 7.1 Final Status Check
```bash
# Check final trap statistics
cast call --rpc-url hoodi VIEWER_ADDRESS "getTrapStats()"
```
]
### 7.2 Complete Alert History
```bash
# Get total alerts for monitored wallet
cast call --rpc-url hoodi VIEWER_ADDRESS \
  "getWalletAlertCount(address)" YOUR_WALLET_ADDRESS
```

### 7.3 Balance Formatting Test
```bash
# Test balance formatting utility
cast call --rpc-url hoodi VIEWER_ADDRESS \
  "getBalanceStrings(uint256)" CURRENT_BALANCE_WEI
```

## 📋 Phase 8: Configuration Setup

### 8.1 Create Drosera Configuration
```bash
cat > drosera.toml << 'EOF'
# Network configuration
ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
drosera_rpc = "https://relay.hoodi.drosera.io"
eth_chain_id = 560048
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]
[traps.eth_balance_monitor]
path = "out/ETHBalanceDropTrap.sol/ETHBalanceDropTrap.json"
address = "YOUR_TRAP_ADDRESS"
response_contract = "YOUR_LOGGER_ADDRESS"
response_function = "logETHDropAlert(address,uint256,uint256,string)"
cooldown_period_blocks = 10
min_number_of_operators = 1
max_number_of_operators = 3
block_sample_size = 5
private_trap = false
whitelist = []
EOF
```

### 8.2 Update Configuration
Replace placeholders in `drosera.toml` with your actual contract addresses:
- `YOUR_TRAP_ADDRESS` → Trap contract address from Phase 3.1
- `YOUR_LOGGER_ADDRESS` → Logger contract address from Phase 3.1

## ✅ Phase 9: Deployment Verification Checklist

### 9.1 Contract Verification
- [ ] All contracts deployed successfully
- [ ] No compilation errors or warnings
- [ ] Contract addresses recorded and verified
- [ ] Balance monitoring working (`collect()` function)
- [ ] Trap logic working (`shouldRespond()` function)

### 9.2 Alert System Verification  
- [ ] Manual alert test successful
- [ ] Events properly emitted and logged
- [ ] Alert count tracking accurate
- [ ] Viewer contract providing readable output

### 9.3 Real Transaction Testing
- [ ] Actual ETH transfer completed
- [ ] Balance change detected by trap
- [ ] shouldRespond logic working with real data
- [ ] No unexpected errors or failures

### 9.4 Configuration Completeness
- [ ] `drosera.toml` created and configured
- [ ] Contract addresses updated in configuration
- [ ] Network settings verified
- [ ] All required parameters set

## 🚀 Phase 10: Production Preparation

### 10.1 Documentation Package
Create comprehensive documentation including:
- [ ] All contract source code
- [ ] Deployment transaction hashes
- [ ] Test results with screenshots
- [ ] Configuration files
- [ ] Usage instructions

### 10.2 Repository Setup
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit: ETH Balance Drop Trap with full test results"

# Push to GitHub (create repository first)
git remote add origin https://github.com/yourusername/eth-balance-drop-trap.git
git push -u origin main
```

## 📊 Test Results Summary

### Deployment Summary
| Component | Address | Status |
|-----------|---------|---------|
| ETH Balance Drop Trap | `_______________` | ✅ Deployed |
| Alert Logger | `_______________` | ✅ Deployed |
| Simple Trap Viewer | `_______________` | ✅ Deployed |

### Test Results Summary
| Test Case | Expected | Actual | Status |
|-----------|----------|--------|---------|
| Contract Compilation | Success | `_______` | ⬜ |
| Trap Deployment | Success | `_______` | ⬜ |
| collect() Function | Current Balance | `_______` | ⬜ |
| shouldRespond() Logic | True/False | `_______` | ⬜ |
| Manual Alert Test | Event Emitted | `_______` | ⬜ |
| Real Transaction Test | Balance Change | `_______` | ⬜ |
| Alert Count Tracking | Accurate Count | `_______` | ⬜ |

### Performance Metrics
- **Gas Usage (Deployment):** `_______________`
- **Gas Usage (Alert):** `_______________`
- **Response Time:** `_______________`
- **Alert Accuracy:** `_______________`

## 🆘 Troubleshooting

### Common Issues and Solutions

**Compilation Errors:**
- Verify Solidity version compatibility (^0.8.19)
- Check OpenZeppelin imports and remappings
- Ensure all dependencies installed correctly

**Deployment Failures:**
- Confirm private key format and funding
- Verify RPC endpoint accessibility
- Check gas price and network congestion

**Function Call Errors:**
- Validate contract addresses
- Confirm function signatures match
- Check data encoding and parameters

**Event Logging Issues:**
- Verify response contract deployment
- Check function selector in drosera.toml
- Confirm transaction confirmation

### Getting Support
- Check [Drosera Documentation](https://dev.drosera.io/)
- Review [Foundry Troubleshooting](https://book.getfoundry.sh/reference/troubleshooting)
- Submit issues to your repository
- Join Drosera community discussions

---

**Deployment Guide Complete** ✅  
*Follow this guide step-by-step with screenshots for complete documentation of your trap deployment and testing process.*
