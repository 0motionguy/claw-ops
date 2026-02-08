---
name: instagram-automation
description: Automate Instagram posting, commenting, DM management, and engagement to replace social media managers. Use when creating content calendars, automating Instagram interactions, managing multiple accounts, or scaling social media presence. Includes Apify integration for scraping, content generation, engagement automation, and analytics tracking.
---

# Instagram Automation

Replace social media managers with AI automation for Instagram.

## Capabilities

### 1. Content Posting
- Schedule posts in advance
- Auto-generate captions with hashtags
- Cross-post from other platforms
- Repost user-generated content

### 2. Comment Automation
- Auto-reply to comments
- Comment on target accounts
- Engagement pods management
- Spam filtering

### 3. DM Management
- Auto-respond to DMs
- Lead qualification
- Appointment booking via DM
- FAQ automation

### 4. Engagement
- Like target accounts' posts
- Story reactions
- Follow/unfollow strategies
- Influencer outreach

## Setup

### Prerequisites
1. Instagram Business Account
2. Apify account (for scraping)
3. Meta Business verification
4. Content strategy defined

### Authentication
Use Apify Instagram Scraper:
```python
from apify_client import ApifyClient

client = ApifyClient("YOUR_API_TOKEN")
```

## Workflows

### Content Calendar Automation
```
1. Define content themes (weekly)
2. Generate content batch (monthly)
3. Schedule posts (weekly)
4. Monitor engagement (daily)
5. Respond to comments (real-time)
6. Analyze performance (weekly)
```

### Lead Generation via DM
```
1. Monitor for keywords in DMs
2. Auto-respond with qualifying questions
3. Score leads based on responses
4. Hot leads → Book appointment
5. Nurture cold leads → Add to sequence
```

### Engagement Growth
```
1. Identify target accounts (hashtags/competitors)
2. Like their recent posts (daily)
3. Leave meaningful comments (daily)
4. Follow active users (daily limit)
5. Track engagement rates (weekly)
```

## Scripts

- `scripts/content-generator.py` - Generate posts/captions
- `scripts/scheduler.py` - Schedule posts
- `scripts/engagement-bot.py` - Like/comment automation
- `scripts/dm-manager.py` - DM responses
- `scripts/analytics.py` - Performance tracking

## Best Practices

### Avoid Getting Banned
- Stay within Instagram limits
- 50-100 likes/hour max
- 20-30 comments/hour max
- 20-30 follows/day max
- Use proxies for multiple accounts
- Vary timing (don't be robotic)

### Content Strategy
- 80% value, 20% promotion
- Post at optimal times ( analyze audience)
- Use 20-30 hashtags
- Include CTAs in captions
- Engage within first hour of posting

## Metrics

Track these KPIs:
- Follower growth rate
- Engagement rate (likes + comments / followers)
- DM conversion rate
- Story completion rate
- Link clicks (if applicable)
- Profile visits

## Resources

- [references/content-templates.md](references/content-templates.md)
- [references/hashtag-strategies.md](references/hashtag-strategies.md)
- [references/instagram-limits.md](references/instagram-limits.md)

## External Tools

- **Apify:** instagram-scraper, instagram-profile-scraper
- **MCP Servers:** instagram-engagement-mcp, instagram-dm-mcp
- **Meta Business Suite:** Official posting/scheduling
