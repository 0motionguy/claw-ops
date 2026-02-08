# Context Trimmer - Token Efficiency Reference

## Overview
Strategies for managing context windows and reducing token usage in AI agent operations.

## Core Principles

### 1. Progressive Disclosure
- Load metadata first (name + description) - ~100 words
- Load SKILL.md body only when skill triggers (<5k words)
- Load bundled resources only as needed (scripts can execute without reading into context)

### 2. Smart Model Routing (from VoltAgent subagents)
| Model | Use For | Examples |
|-------|---------|----------|
| Opus | Deep reasoning, architecture reviews, security audits | Complex analysis, planning |
| Sonnet | Everyday coding, writing, debugging | Most development tasks |
| Haiku | Quick tasks, docs, search, dependency checks | Summaries, simple lookups |

### 3. Tool Permission Granularity
- **Read-only agents** (reviewers): `Read, Grep, Glob` - analyze without modifying
- **Research agents**: `Read, Grep, Glob, WebFetch, WebSearch` - gather information
- **Code writers**: `Read, Write, Edit, Bash, Glob, Grep` - create and execute
- **Documentation**: `Read, Write, Edit, Glob, Grep, WebFetch, WebSearch` - document with research

## Context Management Strategies

### Strategy 1: Summarize Before Passing
When fetching large content (GitHub READMEs, web pages):
1. Fetch raw content
2. Extract key points immediately
3. Pass only summary to next step
4. Discard raw content from context

### Strategy 2: Structured Error Messages
Instead of generic errors, provide structured, actionable feedback:
- What went wrong
- What's needed
- How to fix it
This reduces retry loops and wasted tokens.

### Strategy 3: Concise Prompts
- Use direct, unambiguous prompts
- Avoid verbose explanations
- Prefer examples over descriptions

### Strategy 4: Context Window Monitoring
- Track context size regularly
- Compact/summarize conversation history when approaching limits
- Use `/compact` command in chat interfaces

### Strategy 5: Isolated Subagent Contexts
- Spawn subagents for specialized tasks
- Each subagent has isolated context
- Prevents main conversation clutter
- Enables parallel processing

## Implementation Checklist

When creating new skills:
- [ ] Keep SKILL.md under 500 lines
- [ ] Move detailed info to references/ directory
- [ ] Use YAML frontmatter for triggering metadata
- [ ] Specify minimal tool set needed
- [ ] Include model recommendation in frontmatter
- [ ] Test token usage with sample queries

## References
- VoltAgent/awesome-claude-code-subagents README analysis
- OpenClaw SKILL.md best practices
- Claude Code documentation on context management
