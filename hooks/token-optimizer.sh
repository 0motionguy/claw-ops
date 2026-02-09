#!/bin/bash
# Token Optimizer Hook
# Monitors and optimizes API token usage

DAILY_BUDGET=${TOKEN_BUDGET:-5.00}
CURRENT_SPEND=${TODAY_SPEND:-0}
ALERT_THRESHOLD=0.80

# Check if we're approaching budget limit
usage_percent=$(echo "scale=2; $CURRENT_SPEND / $DAILY_BUDGET" | bc)

if (( $(echo "$usage_percent > $ALERT_THRESHOLD" | bc -l) )); then
    echo "⚠️ TOKEN ALERT: $usage_percent% of daily budget used ($CURRENT_SPEND / $DAILY_BUDGET)"
    echo "Switching to economy mode..."
    export FORCE_CHEAP_MODEL=true
fi

# Route based on task complexity
if [[ "$FORCE_CHEAP_MODEL" == "true" ]] || [[ "$TASK_TYPE" == "simple" ]]; then
    export MODEL_PRIORITY="haiku,sonnet,opus"
else
    export MODEL_PRIORITY="opus,sonnet,haiku"
fi

echo "Token optimizer active. Current: $CURRENT_SPEND / $DAILY_BUDGET"
