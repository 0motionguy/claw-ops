#!/usr/bin/env python3
"""
Polymarket Arbitrage Scanner
Finds profitable arbitrage opportunities across markets

Usage:
    python3 arbitrage-scanner.py --min-spread 2.5
    python3 arbitrage-scanner.py --type negrisk
    python3 arbitrage-scanner.py --output opportunities.json
"""

import argparse
import json
from typing import List, Dict, Optional

class ArbitrageScanner:
    """Scan Polymarket for arbitrage opportunities"""
    
    def __init__(self, min_spread: float = 2.5):
        self.min_spread = min_spread  # Minimum spread % to be profitable
        self.winner_fee = 0.02  # 2% Polymarket fee
        
    def calculate_negrisk_opportunity(self, outcomes: List[Dict]) -> Optional[Dict]:
        """
        Check for NegRisk arbitrage opportunity
        Buy all outcomes when sum < 1.00 - fees
        """
        total_cost = sum(outcome['price'] for outcome in outcomes)
        guaranteed_payout = 1.0
        fees = guaranteed_payout * self.winner_fee
        
        potential_profit = guaranteed_payout - total_cost - fees
        spread_percent = (potential_profit / total_cost) * 100
        
        if spread_percent >= self.min_spread:
            return {
                'type': 'negrisk',
                'market': outcomes[0].get('market_name', 'Unknown'),
                'outcomes': len(outcomes),
                'total_cost': total_cost,
                'potential_profit': potential_profit,
                'spread_percent': spread_percent,
                'action': f"Buy all {len(outcomes)} outcomes"
            }
        return None
    
    def calculate_cross_platform_opportunity(self, 
                                           poly_yes: float, 
                                           poly_no: float,
                                           kalshi_yes: float,
                                           kalshi_no: float) -> Optional[Dict]:
        """
        Check for cross-platform arbitrage
        Buy YES on one, NO on other
        """
        # Strategy 1: Buy Polymarket NO + Kalshi YES
        cost1 = poly_no + kalshi_yes
        profit1 = 1.0 - cost1 - (1.0 * self.winner_fee)
        spread1 = (profit1 / cost1) * 100 if cost1 > 0 else 0
        
        # Strategy 2: Buy Polymarket YES + Kalshi NO
        cost2 = poly_yes + kalshi_no
        profit2 = 1.0 - cost2 - (1.0 * self.winner_fee)
        spread2 = (profit2 / cost2) * 100 if cost2 > 0 else 0
        
        best_strategy = None
        if spread1 >= self.min_spread and spread1 > spread2:
            best_strategy = {
                'type': 'cross_platform',
                'strategy': 'Polymarket NO + Kalshi YES',
                'cost': cost1,
                'profit': profit1,
                'spread_percent': spread1
            }
        elif spread2 >= self.min_spread:
            best_strategy = {
                'type': 'cross_platform',
                'strategy': 'Polymarket YES + Kalshi NO',
                'cost': cost2,
                'profit': profit2,
                'spread_percent': spread2
            }
            
        return best_strategy
    
    def scan_markets(self, markets: List[Dict]) -> List[Dict]:
        """Scan all markets for opportunities"""
        opportunities = []
        
        for market in markets:
            # Check NegRisk opportunities (multi-outcome)
            if len(market.get('outcomes', [])) > 2:
                opp = self.calculate_negrisk_opportunity(market['outcomes'])
                if opp:
                    opp['market_id'] = market.get('id')
                    opportunities.append(opp)
                    
        return opportunities
    
    def print_report(self, opportunities: List[Dict]):
        """Print formatted report"""
        print("=" * 70)
        print(f"🎯 POLYMARKET ARBITRAGE SCANNER")
        print(f"📊 Minimum spread: {self.min_spread}%")
        print("=" * 70)
        print()
        
        if not opportunities:
            print("❌ No profitable opportunities found")
            print("💡 Try lowering --min-spread or wait for market volatility")
            return
            
        print(f"✅ Found {len(opportunities)} opportunities:\n")
        
        for i, opp in enumerate(opportunities, 1):
            print(f"{i}. [{opp['type'].upper()}]")
            if 'market' in opp:
                print(f"   Market: {opp['market']}")
            if 'strategy' in opp:
                print(f"   Strategy: {opp['strategy']}")
            print(f"   Cost: ${opp.get('total_cost', opp.get('cost', 0)):.2f}")
            print(f"   Profit: ${opp['potential_profit']:.2f}")
            print(f"   Spread: {opp['spread_percent']:.2f}%")
            print()
            
        print("=" * 70)
        print("⚡ NEXT STEPS:")
        print("1. Verify liquidity in order books")
        print("2. Check market resolution criteria")
        print("3. Execute trades quickly (opportunities disappear fast)")
        print("=" * 70)

def demo():
    """Demo with sample data"""
    sample_markets = [
        {
            'id': '0x123',
            'market_name': 'Will BTC hit $100K by end of 2025?',
            'outcomes': [
                {'name': 'Yes', 'price': 0.60},
                {'name': 'No', 'price': 0.42}
            ]
        },
        {
            'id': '0x456',
            'market_name': 'Fed Rate Cut by March?',
            'outcomes': [
                {'name': 'Yes', 'price': 0.30},
                {'name': 'No', 'price': 0.35},
                {'name': 'Maybe', 'price': 0.25}  # Total = 0.90 (PROFITABLE!)
            ]
        }
    ]
    
    scanner = ArbitrageScanner(min_spread=2.0)
    opportunities = scanner.scan_markets(sample_markets)
    scanner.print_report(opportunities)
    
    # Show cross-platform example
    print("\n🔄 CROSS-PLATFORM EXAMPLE:")
    cross = scanner.calculate_cross_platform_opportunity(
        poly_yes=0.60, poly_no=0.42,
        kalshi_yes=0.55, kalshi_no=0.47
    )
    if cross:
        print(f"   Strategy: {cross['strategy']}")
        print(f"   Cost: ${cross['cost']:.2f}")
        print(f"   Profit: ${cross['profit']:.2f}")
        print(f"   Spread: {cross['spread_percent']:.2f}%")
    else:
        print("   No profitable cross-platform opportunity")

def main():
    parser = argparse.ArgumentParser(description="Scan Polymarket for arbitrage")
    parser.add_argument("--min-spread", type=float, default=2.5,
                       help="Minimum spread %% to be profitable (default: 2.5)")
    parser.add_argument("--type", choices=["negrisk", "cross", "all"],
                       default="all", help="Type of arbitrage to scan")
    parser.add_argument("--output", help="Save results to JSON file")
    parser.add_argument("--demo", action="store_true",
                       help="Run with sample data")
    args = parser.parse_args()
    
    if args.demo:
        demo()
        return
        
    # TODO: Connect to real Polymarket API
    print("⚠️  Real API integration not yet implemented")
    print("💡 Use --demo flag to see example output")
    print()
    print("To implement:")
    print("1. Get API credentials from Polymarket")
    print("2. Import py_clob_client")
    print("3. Fetch live market data")
    print("4. Run arbitrage calculations")

if __name__ == "__main__":
    main()
