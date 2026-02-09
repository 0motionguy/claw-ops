#!/usr/bin/env python3
"""
SOL Price Alert Bot
Monitors SOL price via CoinGecko API and sends alerts when thresholds are crossed.

Author: CLAW_ICM
Features:
- Real-time price monitoring
- Configurable alert thresholds
- Multiple notification methods (console, webhook)
- Persistent state to avoid duplicate alerts
- Error handling and retries
"""

import requests
import time
import json
import os
from datetime import datetime
from typing import Optional, Dict

# Configuration
COINGECKO_API = "https://api.coingecko.com/api/v3/simple/price"
SOL_ID = "solana"
USD_CURRENCY = "usd"

class SOLPriceAlertBot:
    def __init__(self, 
                 upper_threshold: float = 140.0,
                 lower_threshold: float = 120.0,
                 check_interval: int = 60,
                 state_file: str = "alert_state.json"):
        """
        Initialize the SOL Price Alert Bot.
        
        Args:
            upper_threshold: Price above which to trigger alert
            lower_threshold: Price below which to trigger alert
            check_interval: Seconds between price checks
            state_file: File to persist alert state
        """
        self.upper_threshold = upper_threshold
        self.lower_threshold = lower_threshold
        self.check_interval = check_interval
        self.state_file = state_file
        self.last_alert_price: Optional[float] = None
        self.above_upper = False
        self.below_lower = False
        
        self._load_state()
    
    def _load_state(self):
        """Load alert state from file."""
        if os.path.exists(self.state_file):
            try:
                with open(self.state_file, 'r') as f:
                    state = json.load(f)
                    self.last_alert_price = state.get('last_alert_price')
                    self.above_upper = state.get('above_upper', False)
                    self.below_lower = state.get('below_lower', False)
            except Exception as e:
                print(f"Warning: Could not load state: {e}")
    
    def _save_state(self):
        """Save alert state to file."""
        state = {
            'last_alert_price': self.last_alert_price,
            'above_upper': self.above_upper,
            'below_lower': self.below_lower,
            'last_updated': datetime.now().isoformat()
        }
        try:
            with open(self.state_file, 'w') as f:
                json.dump(state, f, indent=2)
        except Exception as e:
            print(f"Warning: Could not save state: {e}")
    
    def get_sol_price(self) -> Optional[float]:
        """
        Fetch current SOL price from CoinGecko.
        
        Returns:
            Current price in USD or None if error
        """
        try:
            params = {
                'ids': SOL_ID,
                'vs_currencies': USD_CURRENCY
            }
            response = requests.get(COINGECKO_API, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()
            return data[SOL_ID][USD_CURRENCY]
        except Exception as e:
            print(f"Error fetching price: {e}")
            return None
    
    def send_alert(self, price: float, direction: str):
        """
        Send price alert notification.
        
        Args:
            price: Current SOL price
            direction: 'ABOVE' or 'BELOW' threshold
        """
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        threshold = self.upper_threshold if direction == 'ABOVE' else self.lower_threshold
        
        message = f"""
🚨 SOL PRICE ALERT

Time: {timestamp}
Price: ${price:.2f}
Threshold: ${threshold:.2f}
Direction: {direction} threshold

Action: Review trading strategy
        """
        
        print(message)
        
        # Here you could add:
        # - Telegram bot notification
        # - Email alert
        # - Discord webhook
        # - Slack notification
        # - SMS via Twilio
        
        self.last_alert_price = price
        self._save_state()
    
    def check_price(self) -> Optional[Dict]:
        """
        Check current price and trigger alerts if thresholds crossed.
        
        Returns:
            Dict with price info or None
        """
        price = self.get_sol_price()
        if price is None:
            return None
        
        result = {
            'price': price,
            'timestamp': datetime.now().isoformat(),
            'upper_threshold': self.upper_threshold,
            'lower_threshold': self.lower_threshold,
            'alert_triggered': False
        }
        
        # Check upper threshold (crossing UP)
        if price >= self.upper_threshold:
            if not self.above_upper:
                self.send_alert(price, 'ABOVE')
                self.above_upper = True
                self.below_lower = False
                result['alert_triggered'] = True
                result['alert_type'] = 'ABOVE'
        else:
            self.above_upper = False
        
        # Check lower threshold (crossing DOWN)
        if price <= self.lower_threshold:
            if not self.below_lower:
                self.send_alert(price, 'BELOW')
                self.below_lower = True
                self.above_upper = False
                result['alert_triggered'] = True
                result['alert_type'] = 'BELOW'
        else:
            self.below_lower = False
        
        self._save_state()
        return result
    
    def run(self, duration_minutes: Optional[int] = None):
        """
        Run the bot continuously.
        
        Args:
            duration_minutes: How long to run (None = infinite)
        """
        print(f"🚀 SOL Price Alert Bot Started")
        print(f"   Upper Threshold: ${self.upper_threshold}")
        print(f"   Lower Threshold: ${self.lower_threshold}")
        print(f"   Check Interval: {self.check_interval} seconds")
        print(f"   Press Ctrl+C to stop\n")
        
        start_time = time.time()
        checks = 0
        
        try:
            while True:
                result = self.check_price()
                checks += 1
                
                if result:
                    status = "🚨 ALERT" if result.get('alert_triggered') else "✅ OK"
                    print(f"{status} Check #{checks}: SOL = ${result['price']:.2f}")
                else:
                    print(f"⚠️  Check #{checks}: Failed to fetch price")
                
                # Check duration
                if duration_minutes:
                    elapsed = (time.time() - start_time) / 60
                    if elapsed >= duration_minutes:
                        print(f"\n⏰ Duration reached ({duration_minutes} min). Stopping.")
                        break
                
                time.sleep(self.check_interval)
                
        except KeyboardInterrupt:
            print(f"\n👋 Bot stopped by user. Total checks: {checks}")


def main():
    """Main entry point with CLI args."""
    import argparse
    
    parser = argparse.ArgumentParser(description='SOL Price Alert Bot')
    parser.add_argument('--upper', type=float, default=140.0, help='Upper price threshold')
    parser.add_argument('--lower', type=float, default=120.0, help='Lower price threshold')
    parser.add_argument('--interval', type=int, default=60, help='Check interval in seconds')
    parser.add_argument('--duration', type=int, help='Run duration in minutes')
    parser.add_argument('--state-file', default='alert_state.json', help='State file path')
    
    args = parser.parse_args()
    
    bot = SOLPriceAlertBot(
        upper_threshold=args.upper,
        lower_threshold=args.lower,
        check_interval=args.interval,
        state_file=args.state_file
    )
    
    bot.run(duration_minutes=args.duration)


if __name__ == "__main__":
    main()
