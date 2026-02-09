# ClawRouter Analysis - Review & Issues

**Date:** 2026-02-08  
**Source:** GitHub, Hacker News, Community Feedback  
**Status:** Basil experienced issues today

---

## 🔍 WHAT IS CLAWROUTER?

**By:** BlockRunAI  
**Purpose:** Smart LLM router to save 78% on inference costs  
**Mechanism:** 14-dimension weighted scoring → Routes to cheapest capable model

### Key Features:
- **30+ models** (OpenAI, Anthropic, Google, DeepSeek, xAI)
- **One wallet** (USDC on Base blockchain)
- **x402 micropayments** (pay per request)
- **No API keys** needed
- **Local routing** (<1ms, zero external calls)

### Model Tiers:
| Tier | Model | Cost | Use Case |
|------|-------|------|----------|
| SIMPLE | DeepSeek | $0.27/M | Q&A, summaries |
| MEDIUM | GPT-4o-mini | $0.60/M | General tasks |
| COMPLEX | Claude Sonnet | $15.00/M | Complex work |
| REASONING | o3 | Varies | Reasoning tasks |

---

## ✅ PROS (Why People Use It)

### 1. **Cost Savings**
- Claims 78% reduction
- 60% of traffic is "simple" (cheap models work)
- Automatic tier selection

### 2. **Convenience**
- One wallet vs 5+ API keys
- Automatic model selection
- No account management

### 3. **Local Routing**
- 100% local scoring
- <1ms routing time
- No external API calls for routing

### 4. **x402 Micropayments**
- Pay per request
- No monthly commitments
- Blockchain-based (transparent)

---

## ❌ CONS & ISSUES (What Basil Experienced)

### Issue 1: **Wallet/Payment Complexity** 🔴
**Problem:** x402 payment system is complex

**Details:**
- Requires USDC on Base blockchain
- Need to fund wallet before use
- Wallet key stored locally (~/.openclaw/blockrun/wallet.key)
- Cryptographic signing (EIP-712) adds complexity
- Payment failures reported (x402 Issue #623)

**Impact:**
- Setup friction
- Payment failures block usage
- Need crypto knowledge
- Not user-friendly

### Issue 2: **Version Compatibility** 🟡
**Problem:** Version mismatches cause issues

**Details:**
- Need v0.3.21+ for blockrun/auto prefix handling
- OpenClaw strips provider prefixes
- Auto-updates may break things

**Fix:**
```bash
curl -fsSL https://raw.githubusercontent.com/BlockRunAI/ClawRouter/main/scripts/reinstall.sh | bash
openclaw gateway restart
```

### Issue 3: **Port Conflicts** 🟡
**Problem:** Port 8402 conflicts

**Details:**
- ClawRouter uses port 8402
- May conflict with other services
- Need to kill process or restart

**Fix:**
```bash
lsof -i :8402
# Kill process or restart OpenClaw
```

### Issue 4: **New/Unproven** 🟡
**Problem:** Very new project (launched ~Feb 2026)

**Details:**
- 738 GitHub stars (growing fast)
- Limited real-world testing
- Bug reports still coming in
- May have edge cases

### Issue 5: **Blockchain Dependency** 🔴
**Problem:** Requires crypto wallet

**Details:**
- Must have Base network USDC
- Need to manage gas fees
- Wallet security concerns
- Not everyone has crypto

---

## 🎯 SHOULD YOU USE IT?

### ✅ Good For:
- High-volume users (save 78%)
- Crypto-native users
- Technical users comfortable with wallets
- Users with simple queries (60% of traffic)
- Cost-conscious at scale

### ❌ Not Good For:
- **Basil's current situation** (experiencing issues)
- Users needing reliability NOW
- Non-crypto users
- Low-volume users (setup overhead)
- Time-sensitive applications

---

## 💡 ALTERNATIVES TO CLAWROUTER

### Option 1: Manual Model Switching (Current)
**Use Gemini Flash 2.5 as default**
- 75% cheaper than Kimi
- Already configured
- No setup issues
- Reliable

### Option 2: Smart Prompting
**Route manually based on task:**
```
Simple query → /model gemini/gemini-2.5-flash
Coding task → /model kimi (or wait for DeepSeek)
Complex analysis → /model kimi
```

### Option 3: Wait for ClawRouter to Mature
**Check back in 1-2 months**
- Let bugs get fixed
- More community testing
- Better documentation
- Stable release

### Option 4: Build Custom Router
**LOBSTER workflow for model selection**
- Rule-based routing
- No external dependencies
- Full control
- No wallet needed

---

## 🔧 IF YOU WANT TO TRY CLAWROUTER

### Prerequisites:
1. Have USDC on Base network
2. Comfortable with crypto wallets
3. Willing to debug issues
4. Not mission-critical use case

### Installation:
```bash
# Install
curl -fsSL https://raw.githubusercontent.com/BlockRunAI/ClawRouter/main/scripts/reinstall.sh | bash

# Fund wallet with USDC on Base
# (Address printed after install)

# Restart
openclaw gateway restart

# Use
/model blockrun/auto
```

### Troubleshooting:
```bash
# Check version
cat ~/.openclaw/ext/blockrun/version

# Check port conflicts
lsof -i :8402

# Reinstall if issues
curl -fsSL https://raw.githubusercontent.com/BlockRunAI/ClawRouter/main/scripts/reinstall.sh | bash

# Check wallet
ls ~/.openclaw/blockrun/wallet.key
```

---

## 📊 COMPARISON

| Approach | Cost | Complexity | Reliability | Recommendation |
|----------|------|------------|-------------|----------------|
| **Kimi K2.5 only** | $$$ | Low | High | Current (expensive) |
| **Gemini Flash** | $$ | Low | High | ✅ **RECOMMENDED** |
| **ClawRouter** | $ | High | Medium | ⚠️ Wait for fixes |
| **Manual routing** | $$ | Medium | High | Good alternative |

---

## 🎯 RECOMMENDATION FOR BASIL

### Immediate (Tonight):
**Switch to Gemini Flash 2.5**
```bash
# Set as default
openclaw config set model "google/gemini-2.5-flash"

# Or per-session
/model google/gemini-2.5-flash
```
**Result:** 75% cost reduction, no setup issues

### Short-term (This Week):
**Wait for ClawRouter v0.4+**
- Let them fix wallet issues
- More community testing
- Better stability
- Then reconsider

### Long-term:
**Build custom LOBSTER router**
- Rule-based (no ML)
- No external dependencies
- Full control
- Zero blockchain complexity

---

## 📝 BOTTOM LINE

**ClawRouter is promising but too new/unstable for production use.**

**Basil's issues are likely:**
1. Wallet/payment complexity
2. Version compatibility
3. Port conflicts
4. x402 micropayment bugs

**Better path:** Gemini Flash 2.5 NOW (75% savings, reliable), revisit ClawRouter later when mature.

---

*Analysis complete. Don't use ClawRouter until v0.4+ stable release.* 🦞
