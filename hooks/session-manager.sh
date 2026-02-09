#!/bin/bash
# Session Manager Hook
# Manages session history to prevent token bloat

COMMAND="$1"
SESSION_DIR="/Users/andy/.openclaw/workspace/memory"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)

case "$COMMAND" in
    "newsession")
        # Archive current session
        ARCHIVE_FILE="$SESSION_DIR/session_${DATE}_${TIME}.md"
        echo "Archiving session to: $ARCHIVE_FILE"
        
        # Create archive with timestamp
        cat > "$ARCHIVE_FILE" << EOF
# Session Archive - $DATE $TIME
## Context Size Before: $(echo "$SESSION_CONTEXT" | wc -c) bytes
## Archived By: session-manager

$SESSION_CONTEXT
EOF
        
        # Clear current session buffer
        echo "" > /tmp/current_session_buffer
        echo "✅ Session archived. Buffer cleared."
        echo "💰 Token savings: ~$(echo "$SESSION_CONTEXT" | wc -c) bytes per request"
        ;;
        
    "sessionstatus")
        CURRENT_SIZE=$(cat /tmp/current_session_buffer 2>/dev/null | wc -c)
        echo "Current session buffer: $CURRENT_SIZE bytes"
        echo "Estimated cost per request: $(echo "scale=4; $CURRENT_SIZE / 1000 * 0.003" | bc) tokens"
        echo ""
        echo "Recommendation:"
        if [ $CURRENT_SIZE -gt 50000 ]; then
            echo "⚠️ Buffer > 50KB. Run 'newsession' to archive and save tokens."
        else
            echo "✅ Buffer healthy. Continue current session."
        fi
        ;;
        
    "autosession")
        # Check if auto-archive needed
        LAST_ARCHIVE=$(stat -f%m /tmp/last_archive 2>/dev/null || echo 0)
        CURRENT_TIME=$(date +%s)
        TIME_DIFF=$((CURRENT_TIME - LAST_ARCHIVE))
        
        if [ $TIME_DIFF -gt 7200 ]; then  # 2 hours
            echo "Auto-archiving session..."
            touch /tmp/last_archive
            $0 newsession
        fi
        ;;
        
    *)
        echo "Session Manager Commands:"
        echo "  newsession    - Archive current session, clear buffer"
        echo "  sessionstatus - Check current session size"
        echo "  autosession   - Auto-archive if > 2 hours"
        ;;
esac
