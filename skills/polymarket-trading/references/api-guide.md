# Polymarket API Reference

## Authentication

### Get API Credentials
1. Create wallet on Polygon
2. Fund with USDC
3. Generate API key at https://polymarket.com/settings

### Python Client Setup
```python
from py_clob_client.client import ClobClient

client = ClobClient(
    "https://clob.polymarket.com",
    key=PRIVATE_KEY,
    chain_id=137,  # Polygon mainnet
    signature_type=1,
    funder=FUNDER_ADDRESS
)
client.set_api_creds(client.create_or_derive_api_creds())
```

## Core Endpoints

### Markets
```python
# Get all markets
markets = client.get_markets()

# Get specific market
market = client.get_market("0x...")

# Get active markets only
active = client.get_markets(active=True)
```

### Order Book
```python
# Get order book for token
token_id = "0x..."
orderbook = client.get_order_book(token_id)

# Get best price
best_price = client.get_price(token_id, side="buy")
```

### Trading
```python
# Place order
order = client.create_order(
    token_id=token_id,
    side="buy",
    size=100,  # $100
    price=0.55
)

# Cancel order
client.cancel_order(order_id)

# Get trades
trades = client.get_trades()
```

## Rate Limits

- 100 requests/minute (free tier)
- 1000 requests/minute (paid tier)
- Use caching to reduce calls

## Data Structures

### Market Object
```json
{
  "id": "0x...",
  "question": "Will BTC hit $100K by end of 2025?",
  "outcomes": ["Yes", "No"],
  "token_ids": ["0x...", "0x..."],
  "volume": 500000,
  "liquidity": 100000,
  "end_date": "2025-12-31"
}
```

### Order Book
```json
{
  "bids": [
    {"price": 0.55, "size": 1000},
    {"price": 0.54, "size": 2000}
  ],
  "asks": [
    {"price": 0.56, "size": 1500},
    {"price": 0.57, "size": 3000}
  ]
}
```

## Error Handling

Common errors:
- `429` - Rate limit (wait 60 seconds)
- `401` - Invalid API key
- `400` - Insufficient balance
- `500` - Server error (retry)

## WebSocket (Real-time)

```python
import websocket

ws = websocket.WebSocketApp(
    "wss://ws.polymarket.com",
    on_message=on_message
)
ws.run_forever()
```

Events:
- `price_update` - Price changes
- `trade` - New trades
- `orderbook` - Order book updates
