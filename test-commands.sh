#!/bin/bash

# ETH Balance Drop Trap - Testing Commands
# Run these commands to test your trap and get great screenshots!

echo "🌿 ETH Balance Drop Trap - Testing Suite"
echo "========================================"

# Set your contract addresses (update these after deployment)
TRAP_ADDRESS="0x8E9E6ba7285d31a2404bEaeb6215A4bc9383B74C"
LOGGER_ADDRESS="0x12a8fD9771C11caF7B66fBc6054C12BC544096D2" 
VIEWER_ADDRESS="0x..." # Update after deploying TrapLogViewer
WALLET_ADDRESS="0x1B4dE8009d6D17CaB4B955f0d51D35B4AABd47fb"

echo ""
echo "📊 STEP 1: Check Current Status"
echo "================================"

echo "Current wallet balance:"
cast balance $WALLET_ADDRESS --rpc-url hoodi

echo ""
echo "Trap collect() function:"
cast call --rpc-url hoodi $TRAP_ADDRESS "collect()(uint256)"

echo ""
echo "Alert count:"
cast call --rpc-url hoodi $LOGGER_ADDRESS "getAlertCount()(uint256)"

echo ""
echo "🧪 STEP 2: Test Trap Logic"
echo "=========================="

echo "Testing shouldRespond with 15% drop:"
cast call --rpc-url hoodi $TRAP_ADDRESS \
  "shouldRespond(uint256[])" "[10000000000000000000,8500000000000000000]"

echo ""
echo "🚨 STEP 3: Manual Alert Test (Great for Screenshots!)"
echo "====================================================="

echo "Sending manual test alert..."
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  $LOGGER_ADDRESS \
  "logETHDropAlert(address,uint256,uint256,string)" \
  $WALLET_ADDRESS \
  10000000000000000000 \
  8500000000000000000 \
  "📸 Screenshot Test - 15% Balance Drop!"

echo ""
echo "⚡ STEP 4: Real ETH Transfer Test"
echo "================================"

echo "Sending 2 ETH to trigger trap..."
cast send --rpc-url hoodi --private-key $PRIVATE_KEY \
  --to 0x000000000000000000000000000000000000dEaD \
  --value 2ether

echo ""
echo "📋 STEP 5: View Results (Perfect for Screenshots!)"
echo "=================================================="

if [ "$VIEWER_ADDRESS" != "0x..." ]; then
    echo "Latest alert (formatted):"
    cast call --rpc-url hoodi $VIEWER_ADDRESS "getLatestAlert()"
    
    echo ""
    echo "Trap statistics:"
    cast call --rpc-url hoodi $VIEWER_ADDRESS "getTrapStats()"
else
    echo "Deploy TrapLogViewer first, then update VIEWER_ADDRESS"
fi

echo ""
echo "Raw alert count:"
cast call --rpc-url hoodi $LOGGER_ADDRESS "getAlertCount()(uint256)"

echo ""
echo "✅ Testing Complete! Check the results above for your screenshots."
