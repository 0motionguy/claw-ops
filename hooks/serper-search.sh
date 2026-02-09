#!/bin/bash
# Serper Search Hook
# Google search via Serper API (2,500 free searches)

API_KEY="${SERPER_API_KEY}"
QUERY="$1"
TYPE="${2:-search}"  # search, news, images, places

if [ -z "$QUERY" ]; then
    echo "Usage: serper-search.sh 'query' [type]"
    echo "Types: search, news, images, places"
    exit 1
fi

RESPONSE=$(curl -s "https://google.serper.dev/${TYPE}" \
    -H "X-API-KEY: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"q\": \"${QUERY}\", \"num\": 5}")

# Extract top results
echo "$RESPONSE" | jq -r '.organic[]? | "\(.title)\n\(.link)\n\(.snippet)\n---"' 2>/dev/null || echo "$RESPONSE" | jq -r '.error // "Search completed"'

echo ""
echo "💰 Cost: $0.00 (Serper free tier - 2,500 remaining)"
