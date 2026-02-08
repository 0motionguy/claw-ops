---
name: polymarket-trading
description: Trade prediction markets on Polymarket for profit. Use when researching arbitrage opportunities, building automated trading bots, analyzing market data, or executing trading strategies on Polymarket. Covers API integration, arbitrage strategies (NegRisk rebalancing, cross-platform, temporal), bot development, and risk management.
---

# Polymarket Trading

Trade prediction markets for profit using arbitrage, automation, and data analysis.

## Quick Start

1. **Setup**: Get API keys from Polymarket
2. **Strategy**: Choose arbitrage type (NegRisk, cross-platform, temporal)
3. **Bot**: Deploy automation (see scripts/)
4. **Profit**: Monitor and scale

## Arbitrage Strategies

### 1. NegRisk Rebalancing (40% of profits)
**How it works:**
- Markets with mutually exclusive outcomes
- Buy all outcomes when sum < $1.00
- Guaranteed payout = $1.00
- Profit = $1.00 - cost - 2% fee

**Example:**
```
Market: Will it rain tomorrow?
YES: $0.35
NO: $0.38
MAYBE: $0.25
Total: $0.98

Buy all 3 for $0.98
Guaranteed payout: $1.00
Profit: $0.02 - 2% fee = ~$0.00

Need spread > 2.5-3% to be profitable
```

**When to use:**
- Multi-outcome markets
- Sum of prices < $0.97
- High liquidity

### 2. Cross-Platform Arbitrage (30% of profits)
**How it works:**
- Same event on Polymarket + Kalshi/PredictIt
- Buy YES on one, NO on other
- Guaranteed profit when combined cost < $0.95

**Example:**
```
Fed Rate Cut by March:
Polymarket YES: $0.60 | NO: $0.42
Kalshi YES: $0.55 | NO: $0.47

Buy Kalshi YES ($0.55) + Polymarket NO ($0.42) = $0.97
Guaranteed payout: $1.00
Profit: $0.03 - fees
```

**When to use:**
- Major events (elections, Fed decisions)
- Price divergence > 5%
- Both platforms liquid

### 3. Temporal Arbitrage (20% of profits)
**How it works:**
- Buy before major news/event
- Sell after volatility spike
- Time-based profit

**When to use:**
- Scheduled events (debates, announcements)
- News catalysts
- Exit 24-48 hours before resolution

### 4. Whale Following (10% of profits)
**How it works:**
- Track large traders
- Copy their moves with delay
- Signal-augmented strategy

## API Integration

### Python Setup
```python
from py_clob_client.client import ClobClient

HOST = "https://clob.polymarket.com"
CHAIN_ID = 137  # Polygon
PRIVATE_KEY = "<your-private-key>"
FUNDER = "<your-funder-address>"

client = ClobClient(
    HOST,
    key=PRIVATE_KEY,
    chain_id=CHAIN_ID,
    signature_type=1,
    funder=FUNDER
)
client.set_api_creds(client.create_or_derive_api_creds())
```

### Key Endpoints
- `GET /markets` - List all markets
- `GET /orderbook/{token_id}` - Order book data
- `POST /order` - Place order
- `GET /trades` - Trade history

See [references/api-guide.md](references/api-guide.md) for full documentation.

## Risk Management

### Position Sizing
- Max 5% of capital per trade
- Diversify across 10+ markets
- Keep 30% cash for opportunities

### Exit Rules
- Subjective markets: Exit 24-48h before resolution
- Set stop-loss at -20%
- Take profit at +50%

### Fees
- 2% winner fee (built into spread calculations)
- Gas fees on Polygon (minimal)
- Withdrawal fees (check current rates)

## Bot Development

### Architecture
```
Market Scanner → Opportunity Detection → Risk Check → Execution → Monitoring
```

### Key Metrics
- **Spread**: Difference between buy/sell prices
- **Liquidity**: Order book depth
- **Volatility**: Price movement rate
- **Latency**: Execution speed (< 50ms target)

### Scripts
- `scripts/arbitrage-scanner.py` - Find opportunities
- `scripts/auto-trader.py` - Execute trades
- `scripts/whale-tracker.py` - Monitor large traders

## Market Analysis

### What to Trade
✅ High liquidity (> $100K volume)
✅ Objective outcomes (sports, crypto prices)
✅ Scheduled events (debates, releases)
✅ Cross-listed on multiple platforms

❌ Avoid:
- Low liquidity (< $10K)
- Subjective resolution (opinion-based)
- Single oracle markets
- New markets (< 24h old)

### Data Sources
- Polymarket API (primary)
- Kalshi API (cross-platform)
- Twitter/X (sentiment)
- News APIs (event timing)

## Profitability Math

### Break-Even Calculation
```
Spread needed = 2% (winner fee) + gas + slippage
Recommended: 2.5-3% minimum spread

Example:
Buy all outcomes: $0.96
Payout: $1.00
Gross profit: $0.04
Winner fee (2%): $0.02
Gas: $0.001
Net profit: $0.019 (1.9% return)
```

### Annual Returns
- Conservative: 15-25% APR
- Moderate: 25-40% APR
- Aggressive: 40-60% APR (with leverage)

## Resources

- [references/api-guide.md](references/api-guide.md) - API documentation
- [references/strategies.md](references/strategies.md) - Advanced strategies
- [references/bot-setup.md](references/bot-setup.md) - Bot deployment guide

## External Links

- **Official**: https://docs.polymarket.com
- **Python SDK**: https://github.com/Polymarket/py-clob-client
- **AI Agents**: https://github.com/Polymarket/agents
- **Arbitrage Bot**: https://github.com/runesatsdev/polymarket-arbitrage-bot

## Stats

- $40M earned by arbitrage traders (Apr 2024-Apr 2025)
- 2% winner fee (industry standard)
- 100+ markets active daily
- 50ms execution time (competitive bots)
