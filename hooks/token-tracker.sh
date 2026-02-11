#!/usr/bin/env bash
# Token Tracker Hook for OpenClaw
# Tracks daily token usage and switches models when budget exceeded
# Place in: ~/.openclaw/hooks/token-tracker.sh

set -euo pipefail

readonly BUDGET_DAILY_USD="${TOKEN_BUDGET_DAILY:-10.00}"
readonly ALERT_THRESHOLD="${TOKEN_ALERT_THRESHOLD:-0.80}"
readonly SWITCH_THRESHOLD="${TOKEN_SWITCH_THRESHOLD:-0.95}"
readonly TRACKING_FILE="${HOME}/.openclaw/logs/token-usage.jsonl"
readonly STATE_FILE="${HOME}/.openclaw/logs/token-state.json"

# Ensure log directory exists
mkdir -p "$(dirname "$TRACKING_FILE")"

# Initialize state file if not exists
init_state() {
    if [[ ! -f "$STATE_FILE" ]]; then
        cat > "$STATE_FILE" <<EOF
{
  "date": "$(date +%Y-%m-%d)",
  "total_tokens": 0,
  "total_cost_usd": 0.00,
  "model_switches": 0,
  "alerts_sent": 0
}
EOF
    fi
}

# Get current usage
get_usage() {
    local today=$(date +%Y-%m-%d)
    local saved_date=$(jq -r '.date' "$STATE_FILE" 2>/dev/null || echo "")
    
    # Reset if new day
    if [[ "$saved_date" != "$today" ]]; then
        cat > "$STATE_FILE" <<EOF
{
  "date": "$today",
  "total_tokens": 0,
  "total_cost_usd": 0.00,
  "model_switches": 0,
  "alerts_sent": 0
}
EOF
    fi
    
    jq -r '.total_cost_usd' "$STATE_FILE"
}

# Log token usage
log_usage() {
    local model="${1:-unknown}"
    local tokens_in="${2:-0}"
    local tokens_out="${3:-0}"
    local cost_usd="${4:-0.00}"
    
    printf '{"timestamp":"%s","model":"%s","tokens_in":%s,"tokens_out":%s,"cost_usd":%s}\n' \
        "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        "$model" \
        "$tokens_in" \
        "$tokens_out" \
        "$cost_usd" \
        >> "$TRACKING_FILE"
    
    # Update state
    local current_cost=$(get_usage)
    local new_cost=$(echo "$current_cost + $cost_usd" | bc -l 2>/dev/null || echo "$current_cost")
    
    jq --arg cost "$new_cost" '.total_cost_usd = ($cost | tonumber)' "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
}

# Check budget and return recommended model
check_budget() {
    local requested_model="${1:-kimi-coding/k2p5}"
    local current_cost=$(get_usage)
    local budget_percent=$(echo "scale=2; $current_cost / $BUDGET_DAILY_USD" | bc -l 2>/dev/null || echo "0")
    
    # Check if we need to switch to cheap model
    if (( $(echo "$budget_percent >= $SWITCH_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        echo "google/gemini-flash"  # Free/cheap model
        log_alert "SWITCHED_TO_CHEAP_MODEL" "$current_cost" "$budget_percent"
        return 0
    fi
    
    # Check if we should alert
    if (( $(echo "$budget_percent >= $ALERT_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        log_alert "BUDGET_ALERT" "$current_cost" "$budget_percent"
    fi
    
    echo "$requested_model"
}

# Log alert
log_alert() {
    local alert_type="$1"
    local current_cost="$2"
    local percent="$3"
    
    local alert_count=$(jq '.alerts_sent' "$STATE_FILE")
    local new_count=$((alert_count + 1))
    
    jq --arg count "$new_count" '.alerts_sent = ($count | tonumber)' "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"
    
    # Send notification (Telegram if configured)
    if [[ -n "${TELEGRAM_BOT_TOKEN:-}" && -n "${TELEGRAM_CHAT_ID:-}" ]]; then
        local message="🚨 Token Budget Alert: $alert_type
Current: \$$current_cost / \$$BUDGET_DAILY_USD (${percent}%)
Alerts today: $new_count"
        
        curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
            -d "chat_id=${TELEGRAM_CHAT_ID}" \
            -d "text=$message" \
            > /dev/null 2&1 || true
    fi
    
    echo "⚠️  $alert_type: \$$current_cost / \$$BUDGET_DAILY_USD (${percent}%)" >&2
}

# Get model cost (approximate)
get_model_cost() {
    local model="$1"
    local tokens_in="${2:-1000}"
    local tokens_out="${3:-1000}"
    
    case "$model" in
        "anthropic/claude-sonnet-4"|"claude-sonnet-4")
            echo "scale=6; ($tokens_in * 0.000003 + $tokens_out * 0.000015)" | bc -l
            ;;
        "anthropic/claude-haiku-3"|"claude-haiku-3")
            echo "scale=6; ($tokens_in * 0.00000025 + $tokens_out * 0.00000125)" | bc -l
            ;;
        "google/gemini-flash"|"gemini-flash")
            echo "0.00"  # Free tier
            ;;
        "kimi-coding/k2.5"|"kimi-k2.5")
            echo "scale=6; ($tokens_in * 0.000001 + $tokens_out * 0.000003)" | bc -l
            ;;
        *)
            echo "scale=6; ($tokens_in * 0.000005 + $tokens_out * 0.000015)" | bc -l
            ;;
    esac
}

# Main entry point
main() {
    local action="${1:-check}"
    
    init_state
    
    case "$action" in
        check)
            local requested_model="${2:-}"
            check_budget "$requested_model"
            ;;
        log)
            local model="${2:-unknown}"
            local tokens_in="${3:-0}"
            local tokens_out="${4:-0}"
            local cost="${5:-$(get_model_cost "$model" "$tokens_in" "$tokens_out")}"
            log_usage "$model" "$tokens_in" "$tokens_out" "$cost"
            ;;
        status)
            local cost=$(get_usage)
            local percent=$(echo "scale=2; $cost / $BUDGET_DAILY_USD * 100" | bc -l 2>/dev/null || echo "0")
            printf '{"date":"%s","cost_usd":%.2f,"budget_usd":%.2f,"percent":%.1f}\n' \
                "$(date +%Y-%m-%d)" "$cost" "$BUDGET_DAILY_USD" "$percent"
            ;;
        *)
            echo "Usage: $0 {check|log|status} [args...]"
            echo "  check [model]     - Check budget and return recommended model"
            echo "  log model in out  - Log token usage"
            echo "  status            - Show current budget status"
            exit 1
            ;;
    esac
}

main "$@"
