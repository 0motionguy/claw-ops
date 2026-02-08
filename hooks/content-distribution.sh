#!/bin/bash
# Hook: Content Published to Distribution
# Triggers: New blog post, social media post, video uploaded
# Actions: Cross-post, notify subscribers, schedule follow-ups

echo "🎣 CONTENT DISTRIBUTION HOOK ACTIVATED"

CONTENT_TYPE="$1"  # blog, social, video
CONTENT_URL="$2"
CONTENT_TITLE="$3"

echo "New $CONTENT_TYPE published: $CONTENT_TITLE"

# Step 1: Cross-post to other platforms
case $CONTENT_TYPE in
  blog)
    # Share blog to social media
    python3 ../content-creator/scripts/social-writer.py generate \
      --from-url "$CONTENT_URL" \
      --platforms "twitter,linkedin,facebook"
    ;;
  social)
    # Share to newsletter
    echo "Adding to next newsletter: $CONTENT_TITLE"
    ;;
  video)
    # Extract clips for short-form
    python3 ../video-editor/scripts/clip-extractor.py \
      --video "$CONTENT_URL" \
      --output "shorts/"
    ;;
esac

# Step 2: Update content calendar
echo "Marking as published in content calendar"

# Step 3: Track performance
python3 ../analytics-reporter/scripts/social-metrics.py track \
  --content "$CONTENT_URL" \
  --monitor "7days"

echo "✅ Content distribution complete for $CONTENT_TITLE"
