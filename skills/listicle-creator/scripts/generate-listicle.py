#!/usr/bin/env python3
"""
Generate viral listicle content.
Usage: python3 generate-listicle.py --topic "AI security" --num 10 --type tips
"""

import argparse
import random

TIPS_TEMPLATES = [
    "Never {action} without {precaution}",
    "Always {action} before {event}",
    "Use {tool} instead of {alternative}",
    "{action} every {timeframe} without fail",
    "Stop {bad_action}—start {good_action}",
    "The {percentage}% rule: {explanation}",
    "Automate {task} with {tool}",
    "{action} in {timeframe} or less",
    "Set up {system} before you need it",
    "Test {process} with {method} regularly"
]

MISTAKES_TEMPLATES = [
    "{action} without {precaution}",
    "Ignoring {signal} until it's too late",
    "Using {tool} for {wrong_use}",
    "Not {action} until {event}",
    "{bad_action} instead of {good_action}",
    "Forgetting to {action} every {timeframe}",
    "Skipping {process} to save time",
    "{action} manually instead of automating"
]

def generate_tips(topic, num):
    actions = ["optimize", "analyze", "implement", "monitor", "backup", "test", "review", "update", "secure", "validate"]
    precautions = ["testing", "a backup", "validation", "verification", "approval", "sign-off"]
    tools = ["the right software", "automation tools", "AI assistants", "specialized tools"]
    alternatives = ["manual work", "guesswork", "outdated methods", "spreadsheets"]
    events = ["launching", "deploying", "scaling", "hiring", "fundraising"]
    timeframes = ["30 days", "weekly", "daily", "monthly", "quarterly"]
    bad_actions = ["guessing", "ignoring warnings", "skipping steps", "cutting corners"]
    good_actions = ["using data", "following checklists", "automating", "documenting"]
    percentages = ["80", "90", "95", "70", "85"]
    explanations = ["focus on what works", "eliminate what doesn't", "double down on winners", "cut your losses"]
    tasks = ["repetitive work", "manual reporting", "data entry", "status updates"]
    systems = ["monitoring", "alerts", "backups", "documentation", "testing"]
    processes = ["security audits", "performance reviews", "backup restores", "disaster recovery"]
    methods = ["real scenarios", "automated tests", "stress tests", "random sampling"]
    
    tips = []
    for i in range(num):
        template = random.choice(TIPS_TEMPLATES)
        tip = template.format(
            action=random.choice(actions),
            precaution=random.choice(precautions),
            tool=random.choice(tools),
            alternative=random.choice(alternatives),
            event=random.choice(events),
            timeframe=random.choice(timeframes),
            bad_action=random.choice(bad_actions),
            good_action=random.choice(good_actions),
            percentage=random.choice(percentages),
            explanation=random.choice(explanations),
            task=random.choice(tasks),
            system=random.choice(systems),
            process=random.choice(processes),
            method=random.choice(methods)
        )
        tips.append(f"{i+1}. {tip}")
    return tips

def generate_mistakes(topic, num):
    actions = ["deploying", "updating", "deleting", "sharing", "ignoring"]
    precautions = ["testing", "backups", "approval", "verification"]
    tools = ["spreadsheets", "manual processes", "outdated tools"]
    wrong_uses = ["everything", "critical tasks", "scalable work"]
    events = ["it's too late", "problems arise", "customers complain"]
    bad_actions = ["waiting", "hiding", "delaying", "avoiding"]
    good_actions = ["acting immediately", "communicating", "documenting", "learning"]
    timeframes = ["the weekend", "Friday evening", "month-end"]
    processes = ["security checks", "code reviews", "documentation", "testing"]
    
    mistakes = []
    for i in range(num):
        template = random.choice(MISTAKES_TEMPLATES)
        mistake = template.format(
            action=random.choice(actions),
            precaution=random.choice(precautions),
            tool=random.choice(tools),
            wrong_use=random.choice(wrong_uses),
            event=random.choice(events),
            bad_action=random.choice(bad_actions),
            good_action=random.choice(good_actions),
            timeframe=random.choice(timeframes),
            process=random.choice(processes)
        )
        mistakes.append(f"{i+1}. {mistake}")
    return mistakes

def main():
    parser = argparse.ArgumentParser(description="Generate viral listicle content")
    parser.add_argument("--topic", required=True, help="Content topic")
    parser.add_argument("--num", type=int, default=10, help="Number of items (3-21)")
    parser.add_argument("--type", choices=["tips", "mistakes", "ways", "secrets"], 
                       default="tips", help="Type of listicle")
    args = parser.parse_args()
    
    print("=" * 60)
    print(f"📝 {args.num}-{args.type.upper()} LISTICLE GENERATOR")
    print("=" * 60)
    print()
    
    # Title options
    titles = {
        "tips": f"{args.num} tips to improve your {args.topic}",
        "mistakes": f"{args.num} {args.topic} mistakes costing you time and money",
        "ways": f"{args.num} ways to master {args.topic}",
        "secrets": f"{args.num} {args.topic} secrets the pros don't want you to know"
    }
    
    print("📱 SUGGESTED TITLES:")
    print("-" * 60)
    print(titles[args.type])
    print()
    
    # Generate content
    print(f"✅ YOUR {args.num} {args.type.upper()}:")
    print("-" * 60)
    
    if args.type == "tips":
        items = generate_tips(args.topic, args.num)
    elif args.type == "mistakes":
        items = generate_mistakes(args.topic, args.num)
    else:
        items = generate_tips(args.topic, args.num)  # Default to tips
    
    for item in items:
        print(item)
        print()
    
    print("=" * 60)
    print("💡 PRO TIPS:")
    print("• Add 1 controversial tip to drive comments")
    print("• End with 'What's #11? Comment below'")
    print("• Use 'Save this post' CTA (listicles get saved most)")
    print("• Create carousel for LinkedIn")
    print("• Repurpose into Twitter thread")
    print("=" * 60)

if __name__ == "__main__":
    main()
