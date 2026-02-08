# 🎣 AUTOMATION HOOKS

Hooks are bash scripts that connect multiple skills together for automated workflows.

## Available Hooks

### 1. lead-capture-to-crm.sh
**Trigger:** New form submission, social comment, DM
**Actions:**
- Add lead to CRM
- Send welcome email
- Schedule follow-up
- Notify team

**Usage:**
```bash
./hooks/lead-capture-to-crm.sh "John Doe" "john@email.com" "instagram"
```

### 2. content-distribution.sh
**Trigger:** New content published
**Actions:**
- Cross-post to social platforms
- Update content calendar
- Track performance
- Add to newsletter

**Usage:**
```bash
./hooks/content-distribution.sh "blog" "https://example.com/post" "Post Title"
```

### 3. client-onboarding.sh
**Trigger:** Contract signed, payment received
**Actions:**
- Create project workspace
- Send welcome sequence
- Generate intake form
- Schedule kickoff call
- Set up automation

**Usage:**
```bash
./hooks/client-onboarding.sh "Company Name" "contact@company.com" "instagram-automation"
```

### 4. weekly-report.sh
**Trigger:** Every Monday 9 AM (cron)
**Actions:**
- Generate marketing report
- Pull sales pipeline
- Compile financials
- Track competitors
- Trading results
- Executive summary

**Usage:**
```bash
./hooks/weekly-report.sh
```

### 5. social-engagement.sh
**Trigger:** New comment, DM, mention
**Actions:**
- Analyze intent (question, lead, complaint, spam)
- Auto-respond or escalate
- Qualify leads
- Log interaction

**Usage:**
```bash
./hooks/social-engagement.sh "instagram" "comment" "username" "Comment text here"
```

### 6. trading-alert.sh
**Trigger:** Arbitrage opportunity detected
**Actions:**
- Check spread > 2.5%
- Verify capital available
- Calculate position size
- Confirm execution
- Log trade

**Usage:**
```bash
./hooks/trading-alert.sh "negrisk" "Market ID" "3.5" "50.00"
```

### 7. seo-publishing.sh
**Trigger:** New blog post published
**Actions:**
- Submit to Google Search Console
- Submit to Bing
- Update internal links
- Share for backlinks
- Track rankings

**Usage:**
```bash
./hooks/seo-publishing.sh "https://example.com/post" "Post Title"
```

### 8. ad-optimization.sh
**Trigger:** Daily 9 AM, or spend threshold
**Actions:**
- Pull performance data
- Pause ROAS < 1.5
- Scale ROAS > 3.0
- Generate report
- Alert on issues

**Usage:**
```bash
./hooks/ad-optimization.sh
```

### 9. competitor-alert.sh
**Trigger:** Daily scan, or changes detected
**Actions:**
- Scan competitor sites
- Detect changes
- Analyze impact
- Generate alert
- Recommend actions

**Usage:**
```bash
./hooks/competitor-alert.sh
```

## Setting Up Cron Jobs

```bash
# Edit crontab
crontab -e

# Add hooks
echo "0 9 * * 1 /Users/andy/.openclaw/workspace/hooks/weekly-report.sh" | crontab -
echo "0 9 * * * /Users/andy/.openclaw/workspace/hooks/ad-optimization.sh" | crontab -
echo "0 10 * * * /Users/andy/.openclaw/workspace/hooks/competitor-alert.sh" | crontab -
```

## Creating New Hooks

Template:
```bash
#!/bin/bash
# Hook: [Name]
# Triggers: [What triggers it]
# Actions: [What it does]

echo "🎣 [HOOK NAME] ACTIVATED"

# Input parameters
PARAM1="$1"
PARAM2="$2"

# Step 1: [Action]
python3 ../[skill]/scripts/[script].py [args]

# Step 2: [Action]
[command]

echo "✅ [Hook name] complete"
```

## Hook Ideas to Build

- [ ] payment-received.sh - Invoice + accounting
- [ ] review-request.sh - Ask for testimonials
- [ ] churn-risk.sh - Detect at-risk customers
- [ ] content-ideas.sh - Generate from trends
- [ ] meeting-prep.sh - Research attendees
- [ ] follow-up-reminder.sh - Check pending items
