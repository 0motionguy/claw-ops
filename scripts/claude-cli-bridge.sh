#!/usr/bin/env bash
# Claude Code CLI Bridge for OpenClaw v2.0 (Optimized)
# Uses Max plan subscription instead of API calls

set -euo pipefail
IFS=$'\n\t'

# Configuration
readonly WORKING_DIR="${2:-$PWD}"
readonly TEMP_FILE=$(mktemp)
readonly TIMEOUT=120

# Cleanup function
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT INT TERM

# Check prerequisites
check_prerequisites() {
    if ! command -v claude &> /dev/null; then
        echo "❌ Error: Claude Code CLI not found" >&2
        echo "Install: npm install -g @anthropics/claude-code" >&2
        exit 1
    fi
    
    if [[ ! -d "$WORKING_DIR" ]]; then
        echo "❌ Error: Working directory does not exist: $WORKING_DIR" >&2
        exit 1
    fi
}

# Check auth status (non-interactive)
check_auth() {
    if [[ ! -f "$HOME/.claude.json" ]]; then
        echo "❌ Error: Claude Code CLI not authenticated" >&2
        echo "Run: claude auth login" >&2
        exit 1
    fi
    
    # Verify account exists in config
    if ! grep -q "oauthAccount" "$HOME/.claude.json" 2>/dev/null; then
        echo "❌ Error: No OAuth account found" >&2
        echo "Run: claude auth login" >&2
        exit 1
    fi
}

# Main execution
main() {
    local prompt="${1:-}"
    
    # Validate input
    if [[ -z "$prompt" ]]; then
        echo "Usage: $0 '<prompt>' [working_directory]" >&2
        exit 1
    fi
    
    # Check prerequisites
    check_prerequisites
    check_auth
    
    # Write prompt to temp file
    echo "$prompt" > "$TEMP_FILE"
    
    # Change to working directory
    cd "$WORKING_DIR" || exit 1
    
    # Run claude CLI with timeout
    # --print: Non-interactive mode
    # -q: Quiet mode (less verbose)
    if ! timeout "$TIMEOUT" claude --print -q < "$TEMP_FILE"; then
        echo "❌ Error: Claude CLI failed or timed out" >&2
        exit 1
    fi
}

# Run main
main "$@"
