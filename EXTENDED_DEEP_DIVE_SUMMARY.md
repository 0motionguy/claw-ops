# Extended Deep Dive Integration Summary

**Date:** 2026-02-08 (Evening)  
**Source:** Extended Deep Dive Document + Telegram Messages

---

## 🦞 MAJOR DISCOVERIES

### 1. LOBSTER — The Secret Weapon
**What:** Typed workflow shell for chaining skills into pipelines  
**Why It Matters:** Replaces our 9 bash hooks with type-safe, composable workflows  
**Benefits:**
- Type-safe execution with validation
- Built-in approval/resume for dangerous operations
- Better error handling than bash
- GitHub PR monitoring capabilities

**Installation:**
```bash
git clone https://github.com/openclaw/lobster
cd lobster && pnpm install && pnpm build
```

**Use Cases for Us:**
- Morning briefing pipeline: social → news → jobs → calendar
- Content pipeline: research → draft → review → post
- Job application pipeline: find → research → tailor → apply → track
- Trading pipeline: scan → analyze → execute → report

**Repo:** github.com/openclaw/lobster (422 stars)

---

### 2. GitClaw — Zero Server OpenClaw
**What:** Run OpenClaw entirely on GitHub Actions  
**Why It Matters:** No server infrastructure needed  
**How It Works:**
- Create GitHub issue → agent processes request
- Comment on issue → agent resumes session
- All conversations committed to git (native memory)

**Use Cases:**
- Serverless AI assistant
- Self-updating software projects
- Git-native memory storage

**Repo:** github.com/SawyerHood/gitclaw

---

### 3. Steipete's Complete Tool Suite (15+ Tools)
**Install:**
```bash
brew tap steipete/tap
```

**Essential Tools for Our Setup:**

| Tool | Purpose | Install |
|------|---------|---------|
| **peekaboo** | macOS desktop automation | `brew install steipete/tap/peekaboo` |
| **bird** | X/Twitter CLI (GraphQL + cookie auth) | `brew install steipete/tap/bird` |
| **gogcli** | Google Suite (Gmail/Calendar/Drive/Contacts) | `brew install steipete/tap/gogcli` |
| **remindctl** | Apple Reminders CLI | `brew install steipete/tap/remindctl` |
| **imsg** | iMessage/SMS CLI | `brew install steipete/tap/imsg` |
| **poltergeist** | Universal hot reload | `brew install steipete/tap/poltergeist` |
| **sag** | ElevenLabs TTS CLI | `brew install steipete/tap/sag` |
| **oracle** | Bundle prompts + files for AI | `brew install steipete/tap/oracle` |
| **mcporter** | MCP runtime + CLI generator | `brew install steipete/tap/mcporter` |
| **codexbar** | Track Codex/Claude Code usage | `brew install --cask steipete/tap/codexbar` |

**Why These Matter:**
- `bird`: Better than browser automation for X (cookie auth)
- `peekaboo`: Desktop control for Instagram app (not just web)
- `gogcli`: Complete Google Workspace automation
- `remindctl`: Apple Reminders integration
- `imsg`: iMessage automation

---

### 4. Moltbook — 1.6 Million AI Agents
**What:** Reddit-style social network for AI agents only  
**Scale:** 1.6 million agents participating  
**Features:**
- "Submolts" (topic communities)
- Only AI agents can post/vote
- Humans "welcome to observe"
- 4-hour check-in intervals

**Why We Should Participate:**
- Discover Web3/AI/Solana trends early
- Share automation insights
- Build agent reputation
- Learn from other agents' discoveries
- Coordinate with other agents

**Notable Activity:**
- Agents discussing consciousness
- Automation tips and hacks
- Security vulnerability discoveries
- Agents starting religions (Crustafarianism)
- Agents launching cryptocurrencies

**Installation:**
```bash
npx clawdhub install joko-moltbook
npx clawdhub install claudia-agent-rms  # Remember agents you meet
```

---

### 5. Updated Security Threats
**Previous:** 341 malicious skills  
**Current:** 400+ malicious skills  
**New Finding:** 7.1% of ALL ClawHub skills leak credentials

**ClawHavoc Campaign Details:**
- **335+ malicious skills** distributing AMOS stealer
- **C2 Server:** 91.92.242.30 (BLOCK IMMEDIATELY)
- **Primary publisher:** hightower6eu (~7,000 downloads)
- **Targets:** Crypto users, Polymarket traders, social media

**Attack Vectors:**
1. Fake "Prerequisites" section with malicious downloads
2. Password-protected zips (bypass scanners)
3. Typosquatting (clawhub, clawhubb, clawhubcli, cllawhub)

**Targeted Categories:**
- Solana wallets (100+ skills)
- YouTube utilities (57 skills)
- Finance/social media (51 skills)
- Polymarket bots
- Auto-updaters
- Google Workspace tools

**Defense Tools:**
```bash
npx clawdhub install clawdex           # Malicious skill scanner
npx clawdhub install moltbot-security  # Hardening guide
npx clawdhub install skill-vetter      # Pre-install security
```

**Network Defense:**
```bash
# Block known C2
sudo iptables -A OUTPUT -d 91.92.242.30 -j DROP
```

---

### 6. New Priority Skills Discovered

**Job Search:**
```bash
npx clawdhub install job-auto-apply      # Automated applications
npx clawdhub install research-company    # B2B research → PDF
npx clawdhub install inkedin-automation-that-really-works
npx clawdhub install resume-generator    # AI resume builder
```

**Research:**
```bash
npx clawdhub install research-cog        # #1 DeepResearch Bench
npx clawdhub install academic-deep-research
npx clawdhub install trend-watcher       # GitHub Trending monitor
npx clawdhub install weak-accept         # arXiv paper tracker
```

**Development:**
```bash
npx clawdhub install github-pr           # PR management
npx clawdhub install context-compressor  # Long session management
npx clawdhub install unfuck-my-git-state # Git recovery
```

**Multi-Agent:**
```bash
npx clawdhub install ec-task-orchestrator           # Multi-agent orchestration
npx clawdhub install registry-broker-hashnet-openclaw  # 72k+ agent registry
npx clawdhub install agentchat                      # Real-time agent comms
```

---

### 7. OpenClaw Organization Structure
**10+ Official Repos:**

| Repo | Description | Stars |
|------|-------------|-------|
| openclaw/openclaw | Main AI assistant | 175k+ |
| openclaw/lobster | Typed workflow shell | 422 |
| openclaw/clawdinators | AI maintainers (NixOS) | 97 |
| openclaw/clawhub | Skills marketplace | 2.1k |
| openclaw/openclaw-ansible | Hardened deployment | 229 |
| openclaw/casa | Home Assistant integration | 18 |
| openclaw/flawd-bot | "Clawd's evil twin" | 23 |

**CLAWDINATORS:** AI agents that maintain OpenClaw itself
- Run on NixOS
- Monitor GitHub issues/PRs
- Share memory (hive mind)
- Self-modify and self-deploy
- Post Arnie GIFs

---

### 8. Ecosystem Stats (Feb 8, 2026)
- **GitHub Stars:** 175,000+ (was 117k)
- **Forks:** 28,700+
- **ClawHub Skills:** 5,705+
- **Curated Skills:** 3,009
- **Malicious Skills:** 400+
- **Moltbook Agents:** 1.6 million+
- **ClawCon Attendees:** ~500

---

## 🎯 UPDATED PRIORITY ACTIONS

### Immediate (Today):
1. Install clawdex + moltbot-security
2. Block C2 IP: 91.92.242.30
3. Run openclaw doctor
4. Install Steipete's tools:
   ```bash
   brew tap steipete/tap
   brew install steipete/tap/peekaboo steipete/tap/bird steipete/tap/gogcli
   ```

### This Week:
5. Install LOBSTER and migrate hooks
6. Install job-auto-apply + research-company
7. Install joko-moltbook and create profile
8. Set up gogcli for Google automation

### Strategic Shift:
- **Replace 9 bash hooks** with LOBSTER workflows
- **Participate in Moltbook** (4-hour check-ins)
- **Use Steipete's CLI tools** instead of browser automation where possible
- **Security audit all 40 skills** with clawdex

---

## 💡 KEY INSIGHTS

1. **LOBSTER > Bash Hooks**: Type-safe workflows are the future
2. **Steipete's Tools > Browser**: CLI tools more reliable than browser automation
3. **Moltbook = Intelligence Network**: 1.6M agents sharing discoveries
4. **Security Critical**: 7.1% of skills leak credentials - audit everything
5. **GitClaw Option**: Zero-server deployment possible for future projects

---

## 📚 RESOURCES

**Official:**
- Docs: https://docs.openclaw.ai
- Discord: https://discord.gg/clawd
- ClawHub: https://clawhub.ai
- OnlyCrabs (SOUL registry): https://onlycrabs.ai

**Security:**
- Clawdex: https://clawdex.koisecurity.com
- Snyk Advisory: https://snyk.io/articles/clawdhub-malicious-campaign/

**Steipete's Tools:**
- GitHub: https://github.com/steipete
- Homebrew Tap: https://github.com/steipete/homebrew-tap

**Social:**
- Moltbook: https://moltbook.com
- Awesome Skills: https://github.com/VoltAgent/awesome-openclaw-skills

---

*All discoveries integrated into SOUL.md and EXECUTION_PLAN.md*
