#!/usr/bin/env bash
# DROID Twitter Hybrid Workflow v2.0 (Optimized)
# Usage: ./droid-twitter-hybrid.sh <action> <content> [target]

set -euo pipefail
IFS=$'\n\t'

# Configuration
readonly DEVICE="${DROID_DEVICE:-O1E1XT232303000}"
readonly LOG_DIR="${DROID_LOG_DIR:-$HOME/.openclaw/workspace/logs/droid-twitter}"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)
readonly TIMEOUT=30

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log_action() {
    local action="$1"
    local content="${2:-}"
    local target="${3:-}"
    local status="$4"
    printf '[{"timestamp":"%s","action":"%s","content":"%s","target":"%s","status":"%s"}]\n' \
        "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$action" "$content" "$target" "$status" \
        >> "$LOG_DIR/actions_${TIMESTAMP:0:8}.jsonl"
}

# Validate device connection
check_device() {
    if ! adb -s "$DEVICE" shell echo "connected" &>/dev/null; then
        echo "❌ Error: Device $DEVICE not connected" >&2
        exit 1
    fi
}

# Capture screenshot with timeout
capture_screenshot() {
    local name="$1"
    local screenshot_path="/tmp/droid_${name}_${TIMESTAMP}.png"
    
    if ! timeout "$TIMEOUT" adb -s "$DEVICE" shell screencap -p "/data/local/tmp/${name}.png" 2>/dev/null; then
        echo "⚠️ Screenshot capture failed" >&2
        return 1
    fi
    
    if ! timeout "$TIMEOUT" adb -s "$DEVICE" pull "/data/local/tmp/${name}.png" "$screenshot_path" 2>/dev/null; then
        echo "⚠️ Screenshot pull failed" >&2
        return 1
    fi
    
    echo "$screenshot_path"
}

# Open Twitter home
twitter_home() {
    echo "📱 Opening Twitter Home..."
    timeout "$TIMEOUT" adb -s "$DEVICE" shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1
    sleep 3
    capture_screenshot "home"
}

# Open compose screen
twitter_compose() {
    echo "📝 Opening Compose Screen..."
    twitter_home
    timeout "$TIMEOUT" adb -s "$DEVICE" shell input tap 920 1800
    sleep 2
    local screenshot
    screenshot=$(capture_screenshot "compose") || true
    
    echo "✅ Compose screen ready: ${screenshot:-N/A}"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Type or paste your tweet in the text field"
    echo "   2. Review the content"
    echo "   3. Tap the 'Post' button (top right)"
    echo "   4. I'll verify it posted successfully"
    echo ""
}

# Open reply screen
twitter_reply() {
    local tweet_url="${1:-}"
    echo "💬 Opening Reply Screen..."
    
    if [[ -n "$tweet_url" ]]; then
        timeout "$TIMEOUT" adb -s "$DEVICE" shell am start -a android.intent.action.VIEW -d "$tweet_url" com.twitter.android
        sleep 4
    else
        twitter_home
        echo "⚠️ No tweet URL provided. Please tap a tweet manually."
    fi
    
    local screenshot
    screenshot=$(capture_screenshot "reply") || true
    
    echo "✅ Reply screen ready: ${screenshot:-N/A}"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Tap the reply field"
    echo "   2. Type or paste your reply"
    echo "   3. Review the content"
    echo "   4. Tap the 'Post' button"
    echo "   5. I'll verify it posted successfully"
    echo ""
}

# Verify post was successful
verify_post() {
    local action="$1"
    local content="${2:-}"
    local target="${3:-}"
    
    echo "🔍 Verifying post..."
    sleep 3
    
    local screenshot
    screenshot=$(capture_screenshot "verify") || true
    
    timeout "$TIMEOUT" adb -s "$DEVICE" shell uiautomator dump "/data/local/tmp/verify.xml" 2>/dev/null || true
    timeout "$TIMEOUT" adb -s "$DEVICE" pull "/data/local/tmp/verify.xml" "/tmp/droid_verify_${TIMESTAMP}.xml" 2>/dev/null || true
    
    if [[ -f "/tmp/droid_verify_${TIMESTAMP}.xml" ]] && grep -qE "Your tweet was sent|Posted|just now" "/tmp/droid_verify_${TIMESTAMP}.xml" 2>/dev/null; then
        echo "✅ Post verified successfully!"
        log_action "$action" "$content" "$target" "success"
        return 0
    else
        echo "⚠️ Verification inconclusive. Check screenshot: ${screenshot:-N/A}"
        log_action "$action" "$content" "$target" "unverified"
        return 1
    fi
}

# Show usage
show_usage() {
    cat <<EOF
DROID Twitter Hybrid Workflow v2.0

Usage:
  $0 post "<tweet text>"          - Draft and post new tweet
  $0 reply "<reply text>" <url>   - Reply to specific tweet
  $0 open [home|compose]           - Just open Twitter

Environment Variables:
  DROID_DEVICE      - Device ID (default: O1E1XT232303000)
  DROID_LOG_DIR     - Log directory path

Examples:
  $0 post "Hello from DROID! 🦞"
  $0 reply "Great point!" https://twitter.com/user/status/123
  DROID_DEVICE=ABC123 $0 post "Custom device"

EOF
}

# Main execution
main() {
    # Validate device first
    check_device
    
    local action="${1:-}"
    local content="${2:-}"
    local target="${3:-}"
    
    case "$action" in
        post)
            cat <<EOF
═══════════════════════════════════════════════════
  DROID Twitter Hybrid - New Tweet
═══════════════════════════════════════════════════

EOF
            if [[ -n "$content" ]]; then
                echo "📝 Draft Content:"
                echo "   $content"
                echo ""
            fi
            twitter_compose
            read -rp "Press Enter after you've posted..."
            verify_post "post" "$content" ""
            ;;
        
        reply)
            cat <<EOF
═══════════════════════════════════════════════════
  DROID Twitter Hybrid - Reply to Tweet
═══════════════════════════════════════════════════

EOF
            if [[ -n "$content" ]]; then
                echo "💬 Reply Content:"
                echo "   $content"
                echo ""
            fi
            twitter_reply "$target"
            read -rp "Press Enter after you've posted..."
            verify_post "reply" "$content" "$target"
            ;;
        
        open)
            echo "📱 Opening Twitter..."
            case "$content" in
                home)
                    twitter_home
                    ;;
                compose)
                    twitter_compose
                    ;;
                *)
                    twitter_home
                    ;;
            esac
            ;;
        
        *)
            show_usage
            exit 1
            ;;
    esac
}

# Run main
main "$@"
