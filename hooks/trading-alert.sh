#!/bin/bash
# Hook: Trading Opportunity Alert
# Triggers: Arbitrage opportunity detected
# Actions: Calculate risk, execute if criteria met, log trade

echo "🎣 TRADING ALERT HOOK ACTIVATED"

OPPORTUNITY_TYPE="$1"  # negrisk, cross-platform, temporal
MARKET="$2"
SPREAD="$3"
PROFIT="$4"

echo "Opportunity: $OPPORTUNITY_TYPE on $MARKET"
echo "Spread: $SPREAD% | Potential profit: $$PROFIT"

# Step 1: Risk check
if (( $(echo "$SPREAD < 2.5" | bc -l) )); then
  echo "❌ Spread too low ($SPREAD%). Minimum 2.5% required."
  exit 0
fi

# Step 2: Check available capital
CAPITAL=$(python3 ../polymarket-trading/scripts/capital-checker.py)
if (( $(echo "$CAPITAL < 100" | bc -l) )); then
  echo "❌ Insufficient capital ($$CAPITAL)"
  exit 0
fi

# Step 3: Position sizing (max 5% per trade)
POSITION_SIZE=$(echo "$CAPITAL * 0.05" | bc)
echo "Position size: $$POSITION_SIZE"

# Step 4: Confirm execution
read -p "Execute trade? (yes/no): " CONFIRM

if [ "$CONFIRM" = "yes" ]; then
  # Execute trade
  python3 ../polymarket-trading/scripts/auto-trader.py execute \
    --type "$OPPORTUNITY_TYPE" \
    --market "$MARKET" \
    --size "$POSITION_SIZE"
  
  # Log trade
  python3 ../polymarket-trading/scripts/trade-logger.py add \
    --type "$OPPORTUNITY_TYPE" \
    --market "$MARKET" \
    --size "$POSITION_SIZE" \
    --expected-profit "$PROFIT"
  
  # Send notification
  echo "✅ Trade executed: $MARKET for $$POSITION_SIZE"
else
  echo "❌ Trade cancelled"
fi
