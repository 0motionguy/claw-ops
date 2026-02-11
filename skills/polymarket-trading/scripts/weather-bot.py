#!/usr/bin/env python3
"""
Polymarket Weather Bot
Scans weather markets for underpriced odds using Tomorrow.io API
Based on @paonx_eth's proven strategy: $197 → $7,342

Usage:
    python3 weather-bot.py --api-key YOUR_TOMORROW_IO_KEY
    python3 weather-bot.py --city "New York" --dry-run
    python3 weather-bot.py --alert-threshold 15
"""

import argparse
import json
import requests
import os
from typing import Dict, Optional
from datetime import datetime, timedelta

class WeatherBot:
    """
    Weather market arbitrage bot
    
    Algorithm:
    1. Scan Polymarket for temperature/precipitation markets
    2. Get forecast from Tomorrow.io API
    3. Calculate deviation between odds and forecast
    4. Buy when deviation > threshold (15% default)
    """
    
    def __init__(self, tomorrow_api_key: str, alert_threshold: float = 15.0):
        self.tomorrow_api_key = tomorrow_api_key
        self.alert_threshold = alert_threshold  # % deviation to trigger alert
        self.polymarket_api = "https://clob.polymarket.com"
        self.tomorrow_api = "https://api.tomorrow.io/v4/weather/forecast"
        
    def get_weather_forecast(self, city: str, days: int = 3) -> Dict:
        """Get temperature forecast from Tomorrow.io"""
        # Geocode city to lat/lon (simplified - use coordinates in production)
        city_coords = {
            "New York": {"lat": 40.7128, "lon": -74.0060},
            "Los Angeles": {"lat": 34.0522, "lon": -118.2437},
            "Chicago": {"lat": 41.8781, "lon": -87.6298},
            "London": {"lat": 51.5074, "lon": -0.1278},
        }
        
        coords = city_coords.get(city, city_coords["New York"])
        
        url = f"{self.tomorrow_api}"
        params = {
            "location": f"{coords['lat']},{coords['lon']}",
            "apikey": self.tomorrow_api_key,
            "timesteps": "1d",
            "startTime": "now",
            "endTime": (datetime.now() + timedelta(days=days)).isoformat()
        }
        
        try:
            response = requests.get(url, params=params)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"Error fetching weather: {e}")
            return {}
    
    def extract_temperature(self, forecast: Dict, day: int = 0) -> Optional[float]:
        """Extract expected temperature from forecast"""
        try:
            timelines = forecast.get('timelines', {})
            daily = timelines.get('daily', [])
            if len(daily) > day:
                values = daily[day].get('values', {})
                # Use temperatureMax as proxy
                return values.get('temperatureMax')
        except Exception as e:
            print(f"Error parsing forecast: {e}")
        return None
    
    def scan_polymarket_weather_markets(self, city: str) -> Dict:
        """
        Scan Polymarket for weather markets
        Returns mock data for demo - integrate with real API in production
        """
        # Mock market data - replace with actual Polymarket API calls
        mock_markets = {
            "New York": [
                {"outcome": "Temp > 70°F", "odds": 0.35, "market_id": "ny-temp-high"},
                {"outcome": "Temp 60-70°F", "odds": 0.45, "market_id": "ny-temp-med"},
                {"outcome": "Temp < 60°F", "odds": 0.25, "market_id": "ny-temp-low"},
            ],
            "Los Angeles": [
                {"outcome": "Temp > 75°F", "odds": 0.65, "market_id": "la-temp-high"},
                {"outcome": "Temp < 75°F", "odds": 0.40, "market_id": "la-temp-low"},
            ]
        }
        
        return mock_markets.get(city, mock_markets["New York"])
    
    def calculate_implied_probability(self, odds: float) -> float:
        """Convert Polymarket odds to implied probability"""
        return odds  # Polymarket uses $0-1 scale = probability
    
    def calculate_deviation(self, market_odds: float, forecast_probability: float) -> float:
        """
        Calculate deviation between market odds and forecast
        Positive = market undervalues the outcome (buy opportunity)
        """
        return forecast_probability - market_odds
    
    def find_opportunities(self, city: str) -> list:
        """Find weather market arbitrage opportunities"""
        opportunities = []
        
        print(f"\n🌤️  Scanning {city} weather markets...")
        
        # Get forecast
        forecast = self.get_weather_forecast(city)
        temp_forecast = self.extract_temperature(forecast)
        
        if not temp_forecast:
            print("❌ Could not get forecast")
            return opportunities
        
        print(f"📊 Forecast: {temp_forecast}°F")
        
        # Get markets
        markets = self.scan_polymarket_weather_markets(city)
        
        for market in markets:
            outcome = market['outcome']
            odds = market['odds']
            
            # Calculate implied forecast probability based on temperature
            if '>' in outcome:
                threshold = float(outcome.split('>')[1].replace('°F', '').strip())
                forecast_prob = 1.0 if temp_forecast > threshold else 0.3
            elif '<' in outcome:
                threshold = float(outcome.split('<')[1].replace('°F', '').strip())
                forecast_prob = 1.0 if temp_forecast < threshold else 0.3
            else:
                # Range bet
                forecast_prob = 0.5  # Simplified
            
            deviation = self.calculate_deviation(odds, forecast_prob)
            deviation_pct = abs(deviation) * 100
            
            print(f"  {outcome}: Market ${odds:.2f} vs Forecast {forecast_prob:.0%} = {deviation:+.0%}")
            
            if deviation_pct >= self.alert_threshold:
                opportunities.append({
                    'city': city,
                    'outcome': outcome,
                    'market_odds': odds,
                    'forecast_probability': forecast_prob,
                    'deviation': deviation,
                    'deviation_pct': deviation_pct,
                    'action': 'BUY' if deviation > 0 else 'AVOID',
                    'market_id': market['market_id']
                })
        
        return opportunities
    
    def execute_trade(self, opportunity: Dict, dry_run: bool = True):
        """Execute trade on Polymarket"""
        if dry_run:
            print(f"\n🔍 DRY RUN - Would execute:")
            print(f"   Market: {opportunity['city']} - {opportunity['outcome']}")
            print(f"   Action: {opportunity['action']}")
            print(f"   Deviation: {opportunity['deviation_pct']:.1f}%")
            return
        
        # Real execution via Polymarket CLOB API
        print(f"\n🚀 Executing trade:")
        print(f"   Market: {opportunity['market_id']}")
        # TODO: Implement actual order placement
    
    def run(self, cities: list, dry_run: bool = True):
        """Main bot loop"""
        print("="*60)
        print("🦞 Polymarket Weather Bot")
        print("   Based on @paonx_eth's $197 → $7,342 strategy")
        print("="*60)
        
        all_opportunities = []
        
        for city in cities:
            opportunities = self.find_opportunities(city)
            all_opportunities.extend(opportunities)
            
            if opportunities:
                print(f"\n✅ {len(opportunities)} opportunities found in {city}")
                for opp in opportunities:
                    print(f"   💰 {opp['outcome']}: {opp['deviation_pct']:.1f}% deviation")
                    self.execute_trade(opp, dry_run)
            else:
                print(f"\n❌ No opportunities in {city}")
        
        print("\n" + "="*60)
        print(f"Total opportunities: {len(all_opportunities)}")
        print("="*60)
        
        return all_opportunities

def main():
    parser = argparse.ArgumentParser(description='Polymarket Weather Bot')
    parser.add_argument('--api-key', default=os.getenv('TOMORROW_API_KEY'),
                       help='Tomorrow.io API key')
    parser.add_argument('--cities', nargs='+', default=['New York', 'Los Angeles', 'Chicago'],
                       help='Cities to scan')
    parser.add_argument('--alert-threshold', type=float, default=15.0,
                       help='Deviation % to trigger alert (default: 15)')
    parser.add_argument('--dry-run', action='store_true', default=True,
                       help='Simulate without executing trades')
    parser.add_argument('--live', action='store_true',
                       help='Execute real trades (requires Polymarket API)')
    
    args = parser.parse_args()
    
    if not args.api_key:
        print("❌ Error: Tomorrow.io API key required")
        print("   Get free key at: https://www.tomorrow.io/")
        print("   Set via --api-key or TOMORROW_API_KEY env var")
        return
    
    bot = WeatherBot(
        tomorrow_api_key=args.api_key,
        alert_threshold=args.alert_threshold
    )
    
    bot.run(
        cities=args.cities,
        dry_run=not args.live
    )

if __name__ == '__main__':
    main()
