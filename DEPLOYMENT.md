# Deployment Guide

Step-by-step instructions for deploying the ETH Balance Drop Trap.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Private key for deployment wallet
- Testnet ETH for gas fees

## Setup

### 1. Clone and Initialize

```bash
git clone <your-repo>
cd eth-balance-drop-trap
```

### 2. Install Dependencies

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### 3. Configure Environment

```bash
# Create .env file (NEVER commit this!)
echo "PRIVATE_KEY=your_private_key_here" > .env
```

### 4. Update Parameters

Edit `script/DeployETHBalanceTrap.s.sol` with your parameters:

```solidity
ETHBalanceDropTrap trap = new ETHBalanceDropTrap(
    0xYourWalletToMonitor,     // Wallet address
    1000,                      // 10% drop threshold  
    10000000000000000          // 0.01 ETH minimum
);
```

## Deployment Steps

### 1. Compile Contracts

```bash
forge build
```

### 2. Deploy to Testnet

```bash
# HOODI Testnet
forge script script/DeployETHBalanceTrap.s.sol --rpc-url hoodi --broadcast

# Or other testnet
forge script script/DeployETHBalanceTrap.s.sol --rpc-url <RPC_URL> --broadcast
```

### 3. Update Configuration

Copy the deployment addresses to `drosera.toml`:

```toml
response_contract = "0x..." # Response contract address
address = "0x..."           # Trap contract address  
```

## Verification

### Test Contract Functions

```bash
# Test collect function
cast call --rpc-url hoodi TRAP_ADDRESS "collect()(uint256)"

# Test with mock data
cast call --rpc-url hoodi TRAP_ADDRESS \
  "shouldRespond(uint256[])" "[1000000000000000000,800000000000000000]"
```

### Manual Alert Test

```bash
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  RESPONSE_ADDRESS \
  "logETHDropAlert(address,uint256,uint256,string)" \
  MONITORED_WALLET \
  1000000000000000000 \
  800000000000000000 \
  "Test alert - 20% drop"
```

### Check Events

```bash
cast logs --rpc-url hoodi \
  --address RESPONSE_ADDRESS \
  --from-block latest
```

## Production Deployment

### Mainnet Deployment

1. **Fund deployment wallet** with mainnet ETH
2. **Update RPC endpoints** in `foundry.toml`
3. **Deploy with production parameters**
4. **Verify contracts on Etherscan**

### Submit to Drosera

1. **Create GitHub repository** with complete code
2. **Submit trap configuration** to Drosera team
3. **Wait for operator review and approval**
4. **Monitor trap activation**

## Troubleshooting

### Common Issues

**Compilation Errors:**
- Check Solidity version compatibility
- Verify OpenZeppelin imports
- Ensure all dependencies installed

**Deployment Failures:**
- Check private key format
- Verify sufficient gas funds
- Confirm RPC endpoint accessibility

**Function Call Errors:**
- Verify contract addresses
- Check function signatures
- Ensure proper data encoding

### Getting Help

- Check [Drosera Documentation](https://dev.drosera.io/)
- Review [Foundry Book](https://book.getfoundry.sh/)
- Submit issues to repository

## Network Configurations

### HOODI Testnet
```toml
[rpc_endpoints]
hoodi = "https://ethereum-hoodi-rpc.publicnode.com"
```

### Ethereum Mainnet
```toml
[rpc_endpoints]
mainnet = "https://eth.llamarpc.com"
```

Add other networks as needed for your deployment strategy.
