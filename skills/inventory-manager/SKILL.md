---
name: inventory-manager
description: Track and manage inventory levels, orders, suppliers, and stock replenishment. Use when managing physical products, optimizing stock levels, or automating reorder processes.
---

# Inventory Manager

Optimize stock levels and never run out of products.

## Core Functions

### Stock Tracking
- Real-time inventory levels
- Location tracking
- SKU management
- Barcode scanning

### Reordering
- Reorder point calculation
- Automatic purchase orders
- Supplier management
- Lead time tracking

### Demand Forecasting
- Historical analysis
- Seasonal trends
- Safety stock calculation
- EOQ (Economic Order Quantity)

### Reporting
- Stock levels
- Turnover rates
- Dead stock identification
- Cost of goods sold

## Key Metrics

### Inventory Turnover
```
Turnover = Cost of Goods Sold / Average Inventory
```
Higher = better (but not too high = stockouts)

### Days Sales of Inventory (DSI)
```
DSI = (Average Inventory / COGS) × 365
```
Lower = more efficient

### Stockout Rate
```
Stockout Rate = Stockouts / Total Orders
```
Target: <2%

## Reorder Formula
```
Reorder Point = (Average Daily Sales × Lead Time) + Safety Stock

Safety Stock = Z-score × √(Lead Time) × Standard Deviation of Demand
```

## Tools

- TradeGecko
- Cin7
- DEAR Inventory
- Zoho Inventory
- Airtable (simple)

## Scripts

- `scripts/stock-tracker.py` - Monitor levels
- `scripts/reorder-calculator.py` - Determine when to buy
- `scripts/forecast-generator.py` - Predict demand
- `scripts/supplier-reporter.py` - Analyze vendors
