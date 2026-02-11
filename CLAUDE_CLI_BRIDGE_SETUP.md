# Using Claude Code CLI Bridge with OpenClaw

## Option 1: Direct Shell Tool (RECOMMENDED)

OpenClaw can already call shell scripts directly. Use this in your prompts:

```bash
# Instead of relying on default model, explicitly call the bridge
exec:./scripts/claude-cli-bridge.sh "your prompt here" /tmp
```

## Option 2: Set via Environment Variable

```bash
export OPENCLAW_MODEL="shell:/Users/andy/.openclaw/workspace/scripts/claude-cli-bridge.sh"
openclaw gateway restart
```

## Option 3: Per-Request Model Override

In any OpenClaw session, you can override the model:

```
/model shell:/Users/andy/.openclaw/workspace/scripts/claude-cli-bridge.sh
```

## Option 4: Create a Skill

Create a skill that wraps the bridge:

```json
{
  "name": "claude-max",
  "description": "Use Claude Code CLI with Max plan",
  "command": "/Users/andy/.openclaw/workspace/scripts/claude-cli-bridge.sh"
}
```

## Testing the Bridge

```bash
cd ~/.openclaw/workspace
./scripts/claude-cli-bridge.sh "What is 2+2?" /tmp
```

## Notes

- **Slower than API**: CLI has ~2-3s startup time
- **Uses Max plan**: No per-call charges
- **Good for**: Heavy usage sessions where startup time doesn't matter
- **Not ideal for**: Quick queries where latency matters

## Current Status

✅ Bridge script: Working (authenticated with Max plan)
✅ Direct test: `claude --print` responds correctly
⚠️  Full integration: Requires OpenClaw restart or skill wrapper
