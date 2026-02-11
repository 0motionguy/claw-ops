#!/bin/bash
# DROID Twitter Hybrid Workflow
# Usage: ./droid-twitter-hybrid.sh <action> <content> [target]
#
# Actions:
#   post    - Draft new tweet (requires manual Post tap)
#   reply   - Reply to specific tweet (requires manual reply tap)
#   open    - Just open Twitter to specific screen

set -e

DEVICE="O1E1XT232303000"
LOG_DIR="$HOME/.openclaw/workspace/logs/droid-twitter"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure log directory exists
mkdir -p "$LOG_DIR"

log_action() {
    echo "[{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"action\":\"$1\",\"content\":\"$2\",\"target\":\"$3\",\"status\":\"$4\"}]" >> "$LOG_DIR/actions_${TIMESTAMP:0:8}.jsonl"
}

capture_screenshot() {
    local name=$1
    adb -s $DEVICE shell screencap -p /data/local/tmp/${name}.png 2>/dev/null
    adb -s $DEVICE pull /data/local/tmp/${name}.png /tmp/droid_${name}_${TIMESTAMP}.png 2>/dev/null
    echo "/tmp/droid_${name}_${TIMESTAMP}.png"
}

open_twitter_home() {
    echo "📱 Opening Twitter Home..."
    adb -s $DEVICE shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1
    sleep 3
    capture_screenshot "home"
}

open_compose() {
    echo "📝 Opening Compose Screen..."
    open_twitter_home
    adb -s $DEVICE shell input tap 920 1800
    sleep 2
    local screenshot=$(capture_screenshot "compose")
    echo "✅ Compose screen ready: $screenshot"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Type or paste your tweet in the text field"
    echo "   2. Review the content"
    echo "   3. Tap the 'Post' button (top right)"
    echo "   4. I'll verify it posted successfully"
    echo ""
}

open_reply() {
    local tweet_url=$1
    echo "💬 Opening Reply Screen..."
    
    if [ -n "$tweet_url" ]; then
        # Open specific tweet
        adb -s $DEVICE shell am start -a android.intent.action.VIEW -d "$tweet_url" com.twitter.android
        sleep 4
    else
        open_twitter_home
        echo "⚠️ No tweet URL provided. Please tap a tweet manually."
    fi
    
    local screenshot=$(capture_screenshot "reply")
    echo "✅ Reply screen ready: $screenshot"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Tap the reply field"
    echo "   2. Type or paste your reply"
    echo "   3. Review the content"
    echo "   4. Tap the 'Post' button"
    echo "   5. I'll verify it posted successfully"
    echo ""
}

verify_post() {
    echo "🔍 Verifying post..."
    sleep 3
    local screenshot=$(capture_screenshot "verify")
    adb -s $DEVICE shell uiautomator dump /data/local/tmp/verify.xml 2>/dev/null
    adb -s $DEVICE pull /data/local/tmp/verify.xml /tmp/droid_verify_${TIMESTAMP}.xml 2>/dev/null
    
    # Check for success indicators
    if grep -q "Your tweet was sent\|Posted\|just now" /tmp/droid_verify_${TIMESTAMP}.xml 2>/dev/null; then
        echo "✅ Post verified successfully!"
        log_action "$1" "$2" "$3" "success"
        return 0
    else
        echo "⚠️ Verification inconclusive. Check screenshot: $screenshot"
        log_action "$1" "$2" "$3" "unverified"
        return 1
    fi
}

# Main execution
case "$1" in
    post)
        echo "═══════════════════════════════════════════════════"
        echo "  DROID Twitter Hybrid - New Tweet"
        echo "═══════════════════════════════════════════════════"
        echo ""
        if [ -n "$2" ]; then
            echo "📝 Draft Content:"
            echo "   $2"
            echo ""
        fi
        open_compose
        read -p "Press Enter after you've posted..."
        verify_post "post" "$2" ""
        ;;
    
    reply)
        echo "═══════════════════════════════════════════════════"
        echo "  DROID Twitter Hybrid - Reply to Tweet"
        echo "═══════════════════════════════════════════════════"
        echo ""
        if [ -n "$2" ]; then
            echo "💬 Reply Content:"
            echo "   $2"
            echo ""
        fi
        open_reply "$3"
        read -p "Press Enter after you've posted..."
        verify_post "reply" "$2" "$3"
        ;;
    
    open)
        echo "📱 Opening Twitter..."
        case "$2" in
            home)
                open_twitter_home
                ;;
            compose)
                open_compose
                ;;
            *)
                open_twitter_home
                ;;
        esac
        ;;
    
    *)
        echo "DROID Twitter Hybrid Workflow"
        echo ""
        echo "Usage:"
        echo "  $0 post \"<tweet text>\"          - Draft and post new tweet"
        echo "  $0 reply \"<reply text>\" <url>   - Reply to specific tweet"
        echo "  $0 open [home|compose]           - Just open Twitter"
        echo ""
        echo "Examples:"
        echo "  $0 post \"Hello from DROID! 🦞\""
        echo "  $0 reply \"Great point!\" https://twitter.com/user/status/123"
        exit 1
        ;;
esac
