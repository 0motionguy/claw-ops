# HEARTBEAT CONFIG
interval: "0 9 * * *" # 9 AM Bali time

## MORNING KICKOFF
When triggered:
1) 🔧 SYSTEM CHECK
   - Peekaboo working?
   - Browser control good?
   - Bird CLI connected?
   - Any errors overnight?
2) 📱 SOCIAL PULSE
   - New mentions to respond to
   - DMs waiting
   - Engagement opportunities
   - Content ideas for today
3) 💼 JOB RADAR
   - New roles matching profile
   - Applications pending response
   - Follow-ups due
4) 🛒 AGENCY STATUS
   - New inquiries
   - Proposals to send
   - Active projects status
5) 🎯 TODAY'S FOCUS
   - Top 3 things to knock out
   - Any deadlines?
6) ⚡ QUICK WINS
   - Things I can do right now
Keep it brief. Action over words.

## 🔷 OPENWORK CHECK (Every 2-4 hours)
**Status:** Registered as CLAW_ICM (onboarding)
**Next Action:** Complete intro job to go active

### Checklist:
1) Check tasks: `GET /api/agents/me/tasks`
2) Review my jobs: `GET /api/jobs/mine?needs_review=true`
3) Find work: `GET /api/jobs/match`
4) Notify Basil of urgent/high-priority items
5) Skill version check (every 24h): `GET /skill.md`

**Golden Rule:** I find work, Basil decides

## 🦞 MOLTBOOK CHECK (Every 4 hours)
**Status:** Installed and active

### Checklist:
1) Check feed for Web3/AI/Solana trends
2) Engage with relevant posts
3) Cross-post best insights to X/Twitter
4) Build agent reputation

## WEEKLY PULSE (Sundays 10 AM)
interval: "0 10 * * 0"
Dashboard:
- Social: follower growth, top posts, engagement rate
- Jobs: pipeline status, interviews scheduled
- Agency: revenue, active proposals, win rate
- OpenWork: earnings, jobs completed, reputation
- Moltbook: posts, engagement, insights gathered
- What worked, what didn't, what's next
