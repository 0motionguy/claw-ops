---
name: token-optimizer
description: Reduce OpenClaw token usage and API costs through context window optimization, smart model routing, and memory management. Use when experiencing high API costs, hitting token limits, or needing to optimize AI agent performance. Covers context trimming, model selection, memory compaction, and cost monitoring.
---

# Token Optimizer

Reduce OpenClaw token usage by 50-70% while maintaining performance.

## The Problem

OpenClaw sends full conversation history with every request:
- 35,600+ tokens per message (workspace files)
- Context bloats over time
- 56-58% of 400K window used quickly
- $50/day+ in API costs possible

## Solutions

### 1. Context Trimming
```
/context list → See what's loaded
/context disable <file> → Remove bloat
```

**Disable unnecessary files:**
- Disable AGENTS.md if not using multi-agent
- Disable heavy reference files
- Only load skills when needed

### 2. Smart Model Routing
**Use cheap models for simple tasks:**
- **Haiku 3:** Quick tasks, summaries ($0.25/1M tokens)
- **Sonnet 4:** Coding, reasoning ($3/1M tokens)
- **Opus 4:** Complex analysis ($15/1M tokens)

**Routing rules:**
- Code generation → Sonnet
- Simple Q&A → Haiku
- Deep analysis → Opus
- File operations → Sonnet

### 3. Memory Compaction
**Before context fills up:**
1. Extract key facts
2. Write to MEMORY.md
3. Summarize conversation
4. Start fresh context

**Auto-compaction triggers:**
- 70% context full
- 100+ messages
- End of major task

### 4. Session Management
**Use isolated sessions:**
```bash
# Start fresh session
openclaw session new project-name

# Switch between sessions
openclaw session switch main
```

### 5. File Injection Optimization
**Lazy loading pattern:**
- Don't inject all files
- Load references on-demand
- Use grep to find relevant sections

## Scripts

- `scripts/context-analyzer.py` - Analyze token usage
- `scripts/model-router.py` - Auto-select models
- `scripts/memory-compactor.py` - Compress context
- `scripts/cost-monitor.py` - Track API spend

## Configuration

### config.json Optimizations
```json
{
  "model": {
    "default": "claude-sonnet-4",
    "cheap": "claude-haiku-3",
    "expensive": "claude-opus-4"
  },
  "context": {
    "maxTokens": 80000,
    "compactionThreshold": 0.7
  },
  "cache": {
    "enabled": true,
    "ttl": 3600
  }
}
```

## Cost Reduction Strategies

### 1. Batch Operations
- Group related tasks
- Minimize API calls
- Use local processing when possible

### 2. Cache Results
- Cache web searches
- Cache API responses
- Cache file reads

### 3. Use Local LLMs
- Small tasks: Qwen 2.5 7B (free)
- Medium tasks: Llama 3 8B (free)
- Only use Claude when necessary

### 4. Prompt Compression
- Shorter prompts = fewer tokens
- Use bullet points
- Remove filler words
- Be specific

### 5. Response Streaming
- Stream long responses
- Cancel if not needed
- Reduce max_tokens

## Monitoring

### Track These Metrics
- Tokens per request
- Cost per hour/day
- Context window usage
- Model distribution
- Cache hit rate

### Set Alerts
- $10/day spend
- 80% context usage
- 100K tokens/hour

## Quick Wins

1. **Disable unused skills** → Save 10-20% tokens
2. **Use /context disable** → Save 30-40% tokens
3. **Route to Haiku** → Save 80% on simple tasks
4. **Compact memory** → Reset context bloat
5. **Use sessions** → Isolate expensive tasks

## Resources

- [references/cost-analysis.md](references/cost-analysis.md)
- [references/model-comparison.md](references/model-comparison.md)
- [references/context-trimming.md](references/context-trimming.md)

## External Resources

- Token optimization guide: https://help.apiyi.com/en/openclaw-token-cost-optimization-guide-en.html
- GitHub discussion: https://github.com/openclaw/openclaw/discussions/1949
