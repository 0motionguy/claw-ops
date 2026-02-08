# 🚀 APIFY SETUP GUIDE

## Step 1: Create Account
1. Go to: https://console.apify.com/sign-up
2. Sign up with email or Google/GitHub
3. Verify email address
4. Complete profile

## Step 2: Get API Token
1. Go to Settings → Integrations
2. Copy your Personal API token
3. Store securely (1Password or similar)

## Step 3: Install Python Client
```bash
pip install apify-client
```

## Step 4: Test Connection
```python
from apify_client import ApifyClient

client = ApifyClient("YOUR_API_TOKEN")

# Test - get user info
user = client.user().get()
print(f"Logged in as: {user['username']}")
```

## Step 5: Key Actors for Our Business

### Instagram Scraping
**Actor:** `apify/instagram-scraper`
**Use:** Extract posts, comments, profiles
**Cost:** ~$0.001/post

### Google Maps Lead Gen
**Actor:** `compass/crawler-google-places`
**Use:** Find businesses, extract contact info
**Cost:** ~$0.005/place

### LinkedIn Profiles
**Actor:** `apify/linkedin-profile-scraper`
**Use:** Enrich lead data
**Cost:** ~$0.02/profile

### Web Scraping
**Actor:** `apify/web-scraper`
**Use:** Custom website extraction
**Cost:** Variable

## Step 6: Set Up MCP Server

Add to OpenClaw config:
```json
{
  "mcpServers": {
    "apify": {
      "command": "npx",
      "args": ["-y", "apify-mcp-server"],
      "env": {
        "APIFY_TOKEN": "your-token-here"
      }
    }
  }
}
```

## Step 7: Pricing Tiers

**Free Plan:**
- $5 compute credits/month
- 7-day data retention
- Community support

**Starter Plan:** $49/month
- $49 compute credits/month
- 30-day data retention
- Email support

**Scale Plan:** $499/month
- $499 compute credits/month
- 90-day data retention
- Priority support

**Recommendation:** Start with Free, upgrade to Starter when needed

## Step 8: First Scraping Job

### Instagram Profile Scraper
```python
from apify_client import ApifyClient

client = ApifyClient("YOUR_API_TOKEN")

# Run Instagram scraper
actor = client.actor("apify/instagram-scraper")
run = actor.call(run_input={
    "usernames": ["target_profile"],
    "resultsLimit": 50,
    "includeComments": True
})

# Get results
dataset = client.dataset(run["defaultDatasetId"])
results = dataset.list_items().items

for post in results:
    print(f"Post: {post['caption'][:100]}...")
    print(f"Likes: {post['likesCount']}")
```

### Google Maps Lead Extraction
```python
actor = client.actor("compass/crawler-google-places")
run = actor.call(run_input={
    "searchStringsArray": [
        "restaurants in Canggu Bali",
        "marketing agencies in Bali"
    ],
    "maxCrawledPlaces": 100,
    "language": "en"
})

dataset = client.dataset(run["defaultDatasetId"])
for place in dataset.list_items().items:
    print(f"Name: {place['title']}")
    print(f"Phone: {place.get('phone', 'N/A')}")
    print(f"Website: {place.get('website', 'N/A')}")
```

## Step 9: Integration with Our Skills

### instagram-automation skill
Uses Apify for:
- Scraping competitor content
- Finding trending hashtags
- Extracting engagement data
- Monitoring brand mentions

### lead-gen-funnel skill
Uses Apify for:
- Extracting Google Maps leads
- Enriching with LinkedIn data
- Scraping website contacts
- Building prospect lists

### apify-integration skill
Central hub for:
- Managing all actors
- Monitoring credit usage
- Scheduling scrapes
- Processing results

## Step 10: Best Practices

1. **Start Small:** Test with small batches first
2. **Monitor Costs:** Set up budget alerts
3. **Use Proxies:** For social media scraping
4. **Cache Results:** Don't re-scrape unnecessarily
5. **Respect Limits:** Follow rate limits to avoid blocks

## Step 11: Troubleshooting

### "Rate limit exceeded"
- Add delay between requests
- Use residential proxies
- Upgrade plan for higher limits

### "Actor failed"
- Check input parameters
- Review actor documentation
- Contact Apify support

### High costs
- Optimize selectors
- Reduce data extraction
- Use cheaper actors

## Links

- Console: https://console.apify.com
- Store: https://apify.com/store
- Docs: https://docs.apify.com
- API Reference: https://docs.apify.com/api
- Community: https://discord.gg/apify

## Next Steps

1. ✅ Sign up for Apify
2. ✅ Get API token
3. ✅ Install Python client
4. ⬜ Run first scraping job
5. ⬜ Integrate with our skills
6. ⬜ Set up MCP server
7. ⬜ Build automation workflows
