#!/bin/bash
# Ollama Bridge Hook
# Routes simple tasks to local LLM for zero-cost inference

MODEL="${OLLAMA_MODEL:-llama3.2}"
ENDPOINT="${OLLAMA_ENDPOINT:-http://localhost:11434}"
PROMPT="$1"

# Check if Ollama is running
if ! curl -s "$ENDPOINT/api/tags" > /dev/null 2>&1; then
    echo "⚠️ Ollama not running. Falling back to cloud API."
    exit 1
fi

# Generate response via Ollama
RESPONSE=$(curl -s "$ENDPOINT/api/generate" \
    -H "Content-Type: application/json" \
    -d "{
        \"model\": \"$MODEL\",
        \"prompt\": \"$PROMPT\",
        \"stream\": false
    }" | jq -r '.response' 2>/dev/null)

if [ -n "$RESPONSE" ] && [ "$RESPONSE" != "null" ]; then
    echo "$RESPONSE"
    echo "💰 Cost: $0.00 (local inference)"
else
    echo "⚠️ Ollama failed. Falling back to cloud API."
    exit 1
fi
