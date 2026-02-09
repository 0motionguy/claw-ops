#!/bin/bash
# Model Router Hook
# Routes requests to appropriate model based on task type

TASK="$1"
MODEL=""

# Detect task type and route accordingly
if [[ "$TASK" == *"heartbeat"* ]] || [[ "$TASK" == *"HEARTBEAT"* ]]; then
    MODEL="ollama/llama3.2"
elif [[ "$TASK" == *"move"* ]] || [[ "$TASK" == *"copy"* ]] || [[ "$TASK" == *"organize"* ]]; then
    MODEL="anthropic/claude-haiku-3"
elif [[ "$TASK" == *"fetch"* ]] || [[ "$TASK" == *"search"* ]] || [[ "$TASK" == *"scrape"* ]]; then
    MODEL="anthropic/claude-haiku-3"
elif [[ "$TASK" == *"code"* ]] || [[ "$TASK" == *"debug"* ]] || [[ "$TASK" == *"build"* ]]; then
    MODEL="anthropic/claude-sonnet-4"
elif [[ "$TASK" == *"analyze"* ]] || [[ "$TASK" == *"research"* ]]; then
    MODEL="anthropic/claude-sonnet-4"
elif [[ "$TASK" == *"strategy"* ]] || [[ "$TASK" == *"complex"* ]]; then
    MODEL="anthropic/claude-opus-4"
else
    MODEL="anthropic/claude-sonnet-4"  # default
fi

echo "Routing to: $MODEL"
export MODEL_OVERRIDE="$MODEL"
