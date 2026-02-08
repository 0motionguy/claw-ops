#!/usr/bin/env python3
"""
Generate Instagram/TikTok posts with "Comment for Guide" CTAs.
Usage: python3 generate-post.py --topic "AI security" --tips 5 --keyword "SECURE"
"""

import argparse
import random

TEMPLATES = {
    "hook": [
        "Stop making these {num} mistakes with {topic}...",
        "I wish I knew these {num} {topic} tips sooner...",
        "These {num} {topic} secrets changed everything for me...",
        "Most people get {topic} wrong. Here's {num} ways to fix it:",
        "Save this! {num} {topic} tips that actually work:"
    ],
    "cta": [
        "Comment {keyword} and I'll send you the full guide",
        "Type {keyword} for my best {topic} framework",
        "Reply with {keyword} for the complete checklist",
        "Comment {keyword} for exclusive access",
        "Drop a {keyword} below for the template"
    ],
    "tips": [
        "Never [action] without [precaution]",
        "Always [action] before [event]",
        "Use [tool] instead of [alternative]",
        "[Action] every [timeframe] without fail",
        "Stop [bad_action]—start [good_action]",
        "The [percentage]% rule: [explanation]",
        "Automate [task] with [tool]",
        "[Action] in [timeframe] or less"
    ]
}

def generate_hook(topic, num_tips):
    template = random.choice(TEMPLATES["hook"])
    return template.format(num=num_tips, topic=topic)

def generate_tips(topic, num_tips):
    tips = []
    for i in range(num_tips):
        template = random.choice(TEMPLATES["tips"])
        # Replace placeholders with topic-specific content
        tip = template.replace("[action]", f"optimize your {topic}" if i == 0 else "analyze" if i == 1 else "implement")
        tip = tip.replace("[precaution]", "testing")
        tip = tip.replace("[tool]", "the right software")
        tip = tip.replace("[alternative]", "manual work")
        tip = tip.replace("[event]", "launching")
        tip = tip.replace("[timeframe]", "30 days")
        tip = tip.replace("[bad_action]", "guessing")
        tip = tip.replace("[good_action]", "using data")
        tip = tip.replace("[percentage]", "80")
        tip = tip.replace("[explanation]", "focus on what works")
        tip = tip.replace("[task]", "repetitive work")
        tips.append(f"{i+1}. {tip}")
    return tips

def generate_cta(keyword):
    template = random.choice(TEMPLATES["cta"])
    return template.format(keyword=keyword.upper())

def main():
    parser = argparse.ArgumentParser(description="Generate viral social media posts")
    parser.add_argument("--topic", required=True, help="Post topic (e.g., 'AI security')")
    parser.add_argument("--tips", type=int, default=5, help="Number of tips (3-10)")
    parser.add_argument("--keyword", required=True, help="CTA keyword (e.g., 'SECURE')")
    args = parser.parse_args()
    
    print("=" * 50)
    print("🚀 VIRAL POST GENERATOR")
    print("=" * 50)
    print()
    print("📱 INSTAGRAM REEL SCRIPT")
    print("-" * 50)
    print()
    print("[HOOK - 0-3 seconds]")
    print(generate_hook(args.topic, args.tips))
    print()
    print("[TIPS - 3-25 seconds]")
    for tip in generate_tips(args.topic, args.tips):
        print(tip)
    print()
    print("[CTA - 25-30 seconds]")
    print(generate_cta(args.keyword))
    print()
    print("=" * 50)
    print("💡 TIPS FOR SUCCESS:")
    print("• Use trending audio")
    print("• Add text overlays for each tip")
    print("• Include progress bar (Tip 1/5)")
    print("• Respond to DMs within 24 hours")
    print("=" * 50)

if __name__ == "__main__":
    main()
