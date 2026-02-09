#!/bin/bash
# OpenRouter Bridge Hook
# Access 300+ models via single API. Free tier available.

API_KEY="${OPENROUTER_API_KEY}"
ENDPOINT="https://openrouter.ai/api/v1"
PROMPT="$1"

# Try free models first (verified working)
FREE_MODELS=(
    "qwen/qwen3-next-80b-a3b-instruct:free"
    "stepfun/step-3.5-flash:free"
    "nvidia/nemotron-nano-12b-v2-vl:free"
    "liquid/lfm-2.5-1.2b-instruct:free"
)

for MODEL in "${FREE_MODELS[@]}"; do
    RESPONSE=$(curl -s "$ENDPOINT/chat/completions" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$MODEL\",
            \"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]
        }" 2>/dev/null)
    
    if [ -n "$RESPONSE" ] && [[ "$RESPONSE" != *"error"* ]]; then
        echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null
        echo "💰 Model: $MODEL (free tier)"
        exit 0
    fi
done

echo "⚠️ Free models rate limited. Falling back to paid..."
exit 1
