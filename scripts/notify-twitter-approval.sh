#!/bin/bash
# Send DROID Twitter approval request via Telegram
# Usage: ./notify-twitter-approval.sh <action> <content> [target]

BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="1447270711"
DEVICE="O1E1XT232303000"

ACTION=$1
CONTENT=$2
TARGET=$3

# Escape content for JSON
CONTENT_ESCAPED=$(echo "$CONTENT" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g' | tr '\n' ' ')

# Build message
MESSAGE="🦞 *DROID Twitter Approval Request*

*Action:* $ACTION
*Content:* \`$CONTENT_ESCAPED\`"

if [ -n "$TARGET" ]; then
    MESSAGE="$MESSAGE
*Target:* $TARGET"
fi

MESSAGE="$MESSAGE

👉 *Tap to approve:*
\`/approve_twitter $ACTION\`

Or run on Mac:
\`./scripts/droid-twitter-hybrid.sh $ACTION \"$CONTENT\" $TARGET\`"

# Send via Telegram API (requires bot token)
# curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
#     -d "chat_id=${CHAT_ID}" \
#     -d "text=${MESSAGE}" \
#     -d "parse_mode=Markdown" \
#     -d "disable_web_page_preview=true"

echo "$MESSAGE"
echo ""
echo "(Telegram integration requires bot token configuration)"
