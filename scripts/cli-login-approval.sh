#!/bin/bash
# CLI Login Approval System
# Usage: ./cli-login-approval.sh <service>
# Services: github, twitter, linkedin, moltbook, openwork

set -e

SERVICE=$1
LOG_FILE="$HOME/.openclaw/workspace/logs/auth-approvals.log"
mkdir -p "$HOME/.openclaw/workspace/logs"

log_auth() {
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $1: $2" >> "$LOG_FILE"
}

github_device_flow() {
    echo "🔐 GitHub Device Flow Authentication"
    echo ""
    
    # Request device code
    RESPONSE=$(curl -s -X POST \
        -H "Accept: application/json" \
        -d "client_id=Ov23liZ7x7JLzHYsonTN" \
        -d "scope=repo workflow" \
        https://github.com/login/device/code)
    
    DEVICE_CODE=$(echo "$RESPONSE" | grep -o '"device_code":"[^"]*"' | cut -d'"' -f4)
    USER_CODE=$(echo "$RESPONSE" | grep -o '"user_code":"[^"]*"' | cut -d'"' -f4)
    VERIFICATION_URI=$(echo "$RESPONSE" | grep -o '"verification_uri":"[^"]*"' | cut -d'"' -f4)
    INTERVAL=$(echo "$RESPONSE" | grep -o '"interval":[0-9]*' | cut -d':' -f2)
    
    echo "📱 Device Code: $USER_CODE"
    echo "🔗 Open: $VERIFICATION_URI"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Copy this code: $USER_CODE"
    echo "   2. Visit: $VERIFICATION_URI"
    echo "   3. Paste the code and authorize"
    echo ""
    
    # Open browser automatically (Mac)
    if command -v open >/dev/null; then
        open "$VERIFICATION_URI"
        echo "   (Browser opened automatically)"
    fi
    
    read -p "   Press ENTER after you've authorized..."
    
    # Poll for token
    echo ""
    echo "⏳ Waiting for authorization..."
    
    for i in {1..30}; do
        TOKEN_RESPONSE=$(curl -s -X POST \
            -H "Accept: application/json" \
            -d "client_id=Ov23liZ7x7JLzHYsonTN" \
            -d "device_code=$DEVICE_CODE" \
            -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
            https://github.com/login/oauth/access_token)
        
        if echo "$TOKEN_RESPONSE" | grep -q "access_token"; then
            ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"ghp_[^"]*"' | cut -d'"' -f4)
            echo ""
            echo "✅ AUTHENTICATED SUCCESSFULLY"
            echo ""
            echo "🔑 Token: ${ACCESS_TOKEN:0:20}..."
            echo ""
            echo "👉 Configure with:"
            echo "   gh auth login --with-token <<< '$ACCESS_TOKEN'"
            echo ""
            log_auth "github" "success"
            return 0
        fi
        
        sleep ${INTERVAL:-5}
        echo -n "."
    done
    
    echo ""
    echo "❌ Timeout waiting for authorization"
    log_auth "github" "timeout"
    return 1
}

twitter_cookie_auth() {
    echo "🔐 Twitter Cookie Authentication"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Open Chrome and go to x.com"
    echo "   2. Log in to your account"
    echo "   3. Open DevTools (Cmd+Option+I)"
    echo "   4. Go to Application → Cookies"
    echo "   5. Find and copy:"
    echo "      • auth_token"
    echo "      • ct0"
    echo ""
    
    # Open browser
    if command -v open >/dev/null; then
        open "https://x.com"
        echo "   (Browser opened to x.com)"
    fi
    
    read -p "   Press ENTER when ready to input tokens..."
    
    echo ""
    read -s -p "   auth_token: " AUTH_TOKEN
    echo ""
    read -s -p "   ct0: " CT0
    echo ""
    
    # Test tokens
    TEST_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer $AUTH_TOKEN" \
        -H "x-csrf-token: $CT0" \
        -H "Cookie: auth_token=$AUTH_TOKEN; ct0=$CT0" \
        https://api.twitter.com/2/users/me)
    
    if [ "$TEST_RESPONSE" = "200" ]; then
        echo ""
        echo "✅ AUTHENTICATED SUCCESSFULLY"
        echo ""
        echo "👉 Export for Bird CLI:"
        echo "   export AUTH_TOKEN='$AUTH_TOKEN'"
        echo "   export CT0='$CT0'"
        echo ""
        log_auth "twitter" "success"
        return 0
    else
        echo ""
        echo "❌ Authentication failed (HTTP $TEST_RESPONSE)"
        log_auth "twitter" "failed"
        return 1
    fi
}

linkedin_auth() {
    echo "🔐 LinkedIn Authentication"
    echo ""
    echo "👉 ACTION REQUIRED:"
    echo "   1. Run Playwright browser:"
    echo "      python3 linkedin.py browser"
    echo "   2. Log in to LinkedIn manually"
    echo "   3. Save session"
    echo ""
    echo "   OR provide cookies:"
    echo "      li_at, JSESSIONID from browser"
    echo ""
    
    read -p "   Press ENTER after LinkedIn is logged in..."
    
    # Check if session file exists
    if [ -f "$HOME/.linkedin_session.json" ]; then
        echo ""
        echo "✅ Session file found"
        log_auth "linkedin" "success"
        return 0
    else
        echo ""
        echo "⚠️  Session file not found"
        echo "   Expected: ~/.linkedin_session.json"
        log_auth "linkedin" "not_found"
        return 1
    fi
}

show_menu() {
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "  CLI Login Approval System"
    echo "═══════════════════════════════════════════════════"
    echo ""
    echo "Usage: $0 <service>"
    echo ""
    echo "Available services:"
    echo "   github      - GitHub device flow (for repo push)"
    echo "   twitter     - Twitter cookie auth (for Bird CLI)"
    echo "   linkedin    - LinkedIn session auth"
    echo ""
    echo "Recent approvals:"
    tail -5 "$LOG_FILE" 2>/dev/null || echo "   (No approvals yet)"
    echo ""
}

# Main
case "$SERVICE" in
    github)
        github_device_flow
        ;;
    twitter)
        twitter_cookie_auth
        ;;
    linkedin)
        linkedin_auth
        ;;
    *)
        show_menu
        exit 1
        ;;
esac
