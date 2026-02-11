#!/bin/bash
# Claude Code CLI Bridge for OpenClaw
# Uses Max plan subscription instead of API calls

set -e

PROMPT="$1"
WORKING_DIR="${2:-$PWD}"

if [ -z "$PROMPT" ]; then
    echo "Usage: $0 '<prompt>' [working_directory]"
    exit 1
fi

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "Error: Claude Code CLI not found"
    echo "Install: npm install -g @anthropics/claude-code"
    exit 1
fi

# Check auth status
if ! claude auth status &> /dev/null; then
    echo "Error: Claude Code CLI not authenticated"
    echo "Run: claude auth login"
    exit 1
fi

# Create temporary file for prompt
TEMP_FILE=$(mktemp)
echo "$PROMPT" > "$TEMP_FILE"

# Run claude CLI with the prompt
# --print: Non-interactive mode
# -q: Quiet mode
cd "$WORKING_DIR"
claude --print -q < "$TEMP_FILE"

# Cleanup
rm "$TEMP_FILE"
