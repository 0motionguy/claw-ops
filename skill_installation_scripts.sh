#!/bin/bash
# Skill Installation Scripts - Ready for Basil
# Generated: 2026-02-08
# These scripts require Basil's input/funds

# ============================================
# PHASE 5: SKILL PREPARATION
# ============================================

echo "🚀 SKILL INSTALLATION SCRIPTS"
echo "=============================="
echo ""

# ============================================
# 1. BANKR - Multi-chain Trading
# REQUIRES: Signup at bankr.bot + $5K funding
# ============================================
echo "1. BANKR (Trading)"
echo "   Status: REQUIRES ACTION"
echo ""
echo "   Steps:"
echo "   a) Visit https://bankr.bot"
echo "   b) Sign up with email"
echo "   c) Get API key (starts with bk_...)"
echo "   d) Configure:"
echo ""
cat << 'EOF'
   mkdir -p ~/.openclaw/skills/bankr
   cat > ~/.openclaw/skills/bankr/config.json << 'CONFIG'
   {
     "apiKey": "bk_YOUR_KEY_HERE",
     "apiUrl": "https://api.bankr.bot"
   }
   CONFIG
EOF
echo ""
echo "   e) Transfer $5K to bankr wallet"
echo "   f) Test: 'Buy $10 of ETH'"
echo ""

# ============================================
# 2. JOB-AUTO-APPLY - Automated Applications
# REQUIRES: LinkedIn credentials
# ============================================
echo "2. JOB-AUTO-APPLY"
echo "   Command: npx clawdhub install job-auto-apply"
echo "   Status: Ready to install"
echo ""

# ============================================
# 3. RESEARCH-COMPANY - B2B Intelligence
# FREE - Install anytime
# ============================================
echo "3. RESEARCH-COMPANY"
echo "   Command: npx clawdhub install research-company"
echo "   Status: Ready to install"
echo ""

# ============================================
# 4. INKEDIN-AUTOMATION - LinkedIn Automation
# REQUIRES: LinkedIn credentials
# ============================================
echo "4. INKEDIN-AUTOMATION-THAT-REALLY-WORKS"
echo "   Command: npx clawdhub install inkedin-automation-that-really-works"
echo "   Status: REQUIRES LinkedIn login"
echo ""

# ============================================
# 5. JOKO-MOLTBOOK - Agent Social Network
# FREE - Install anytime
# ============================================
echo "5. JOKO-MOLTBOOK"
echo "   Command: npx clawdhub install joko-moltbook"
echo "   Status: Ready to install"
echo ""

# ============================================
# 6. TWEET-WRITER - Viral Content
# FREE - Install anytime
# ============================================
echo "6. TWEET-WRITER"
echo "   Command: npx clawdhub install tweet-writer"
echo "   Status: Ready to install"
echo ""

# ============================================
# 7. REPLY - Engagement Optimization
# FREE - Install anytime
# ============================================
echo "7. REPLY"
echo "   Command: npx clawdhub install reply"
echo "   Status: Ready to install"
echo ""

# ============================================
# 8. RESEARCH-COG - Deep Research
# FREE - Install anytime
# ============================================
echo "8. RESEARCH-COG (#1 DeepResearch Bench)"
echo "   Command: npx clawdhub install research-cog"
echo "   Status: Ready to install"
echo ""

echo "=============================="
echo "READY TO INSTALL NOW (FREE):"
echo "  - job-auto-apply"
echo "  - research-company"
echo "  - joko-moltbook"
echo "  - tweet-writer"
echo "  - reply"
echo "  - research-cog"
echo ""
echo "REQUIRES BASIL ACTION:"
echo "  - bankr (signup + $5K)"
echo "  - inkedin-automation (LinkedIn auth)"
echo ""
