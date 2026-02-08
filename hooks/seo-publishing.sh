#!/bin/bash
# Hook: SEO Content Publishing
# Triggers: New blog post published
# Actions: Submit to search engines, update sitemap, notify subscribers

echo "🎣 SEO PUBLISHING HOOK ACTIVATED"

POST_URL="$1"
POST_TITLE="$2"

echo "New post published: $POST_TITLE"
echo "URL: $POST_URL"

# Step 1: Submit to Google Search Console
echo "Submitting to Google..."
curl -X POST "https://www.google.com/webmasters/tools/ping?sitemap=$POST_URL"

# Step 2: Submit to Bing
echo "Submitting to Bing..."
curl -X POST "https://www.bing.com/webmaster/api.svc/ping?sitemap=$POST_URL"

# Step 3: Update internal links
python3 ../seo-optimizer/scripts/internal-linker.py update \
  --new-url "$POST_URL" \
  --topic "$POST_TITLE"

# Step 4: Share to social for backlinks
python3 ../content-creator/scripts/social-writer.py generate \
  --from-url "$POST_URL" \
  --platforms "twitter,linkedin" \
  --focus "backlinks"

# Step 5: Track ranking
python3 ../seo-optimizer/scripts/rank-tracker.py add \
  --url "$POST_URL" \
  --keywords "auto-extracted"

echo "✅ SEO publishing complete for $POST_TITLE"
