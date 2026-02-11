# DROID Twitter Knowledge Base

**Objective:** Single source of truth for running Twitter operations using **DROID as an ADB-controlled device** and **Mac/AWS as the controller/brain**.

**Last Updated:** Feb 11, 2026

---

## 1) Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTROLLER (Mac/AWS)                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ OpenClaw     │  │ Skills       │  │ Approvals    │      │
│  │ Brain        │  │ (safe-exec,  │  │ (Telegram)   │      │
│  │              │  │  prompt-guard│  │              │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                 │               │
│         └─────────────────┼─────────────────┘               │
│                           │                                 │
│                    ┌──────▼───────┐                        │
│                    │   Decision   │                        │
│                    │   Engine     │                        │
│                    └──────┬───────┘                        │
│                           │                                 │
│         ┌─────────────────┼─────────────────┐               │
│         │                 │                 │               │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐      │
│  │ 1. Decide    │  │ 2. Approve   │  │ 3. Act       │      │
│  │ (Draft +     │  │ (Human-in-   │  │ (ADB UI      │      │
│  │  Intent)     │  │  loop)       │  │  Automation) │      │
│  └──────────────┘  └──────────────┘  └──────┬───────┘      │
│                                              │               │
└──────────────────────────────────────────────┼───────────────┘
                                               │
                              ADB (USB/Network) │
                                               │
┌──────────────────────────────────────────────┼───────────────┐
│                    DROID (Saga)               │               │
│  ┌───────────────────────────────────────────┘               │
│  │                                                           │
│  │  ┌──────────────┐  ┌──────────────┐                      │
│  │  │ Twitter App  │  │ UI Automator │                      │
│  │  │ (com.twitter.│  │ (Dump/Select)│                      │
│  │  │  android)    │  │              │                      │
│  │  └──────────────┘  └──────────────┘                      │
│  │                                                           │
│  └───────────────────────────────────────────────────────────┘
```

### Data Flow
1. **Decide** (draft + intent classification)
2. **Approve** (human-in-the-loop via Telegram)
3. **Act** (ADB UI automation)
4. **Verify** (post-action screenshot + state check)
5. **Log** (audit trail)

---

## 2) Prerequisites Checklist

### Controller (Mac/AWS)
- [x] `safe-exec` installed
- [x] `openclaw-hardener` installed
- [x] `soul-guardian` installed
- [x] `skill-scanner` installed
- [x] `prompt-guard` installed
- [x] `stranger-danger` installed
- [x] `auto-updater` installed
- [x] `context-recovery` installed
- [ ] `context-compressor` (not found in registry)

### DROID (Saga)
- [x] Android Developer Options enabled
- [x] USB Debugging enabled
- [x] ADB connected (verified below)
- [x] Twitter app installed (`com.twitter.android`)
- [ ] Wireless ADB pairing (optional, for wireless control)

### Connection Verified
```bash
$ adb devices
List of devices attached
O1E1XT232303000	device  # ✅ Connected

$ adb -s O1E1XT232303000 shell getprop ro.product.model
Saga  # ✅ Solana Mobile Saga

$ adb -s O1E1XT232303000 shell getprop ro.build.version.release
14  # ✅ Android 14

$ adb -s O1E1XT232303000 shell pm list packages | grep -i twitter
package:com.twitter.android  # ✅ Twitter app confirmed
```

---

## 3) ADB Recipes (Copy/Paste Commands)

### Device Connection
```bash
# List connected devices
adb devices

# Connect to specific device (if multiple)
adb -s O1E1XT232303000 <command>

# Connect via network (after USB pairing)
adb tcpip 5555
adb connect 192.168.0.186:5555
```

### Screenshot Capture
```bash
# Capture screenshot and pull to local
adb -s O1E1XT232303000 shell screencap -p /data/local/tmp/screen.png
adb -s O1E1XT232303000 pull /data/local/tmp/screen.png /tmp/screen.png
```

### UIAutomator Dump (XML Hierarchy)
```bash
# Dump UI hierarchy to XML
adb -s O1E1XT232303000 shell uiautomator dump /data/local/tmp/window_dump.xml
adb -s O1E1XT232303000 pull /data/local/tmp/window_dump.xml /tmp/window_dump.xml
```

### Touch/Input Commands
```bash
# Tap at coordinates (x, y)
adb -s O1E1XT232303000 shell input tap 920 1800

# Swipe from (x1, y1) to (x2, y2) [duration_ms]
adb -s O1E1XT232303000 shell input swipe 540 1200 540 600 300

# Type text (URL-encoded for special chars)
adb -s O1E1XT232303000 shell input text "Hello%20World"

# Press key (back=4, home=3, recent apps=187)
adb -s O1E1XT232303000 shell input keyevent 4  # Back button
adb -s O1E1XT232303000 shell input keyevent 3  # Home button
```

### App Launching
```bash
# Launch Twitter app
adb -s O1E1XT232303000 shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1

# Force stop Twitter
adb -s O1E1XT232303000 shell am force-stop com.twitter.android
```

---

## 4) Twitter UI Map (Selectors-First)

### Device: Solana Mobile Saga
**Resolution:** 1080x2400 (portrait)
**Android Version:** 14
**Twitter Package:** com.twitter.android

### Home Feed Screen
**Screenshot:** ![Home Feed](/tmp/twitter_app_home_2.png)

**Key Elements:**
| Element | UIAutomator Selector | Fallback Coordinates | Notes |
|---------|---------------------|---------------------|-------|
| Compose Button | `resource-id="com.twitter.android:id/composer_write_button"` | (920, 1800) | Blue circle with + |
| Home Tab | `content-desc="Home"` | (90, 2100) | Bottom nav |
| Search Tab | `content-desc="Search and Explore"` | (270, 2100) | Bottom nav |
| Notifications | `content-desc="Notifications"` | (630, 2100) | Bottom nav |
| Messages | `content-desc="Direct Messages"` | (810, 2100) | Bottom nav |

### Compose Screen
**Key Elements:**
| Element | UIAutomator Selector | Fallback Coordinates | Notes |
|---------|---------------------|---------------------|-------|
| Text Field | `resource-id="com.twitter.android:id/tweet_text"` | (540, 600) | "What's happening?" |
| Post Button | `resource-id="com.twitter.android:id/button_send_tweet"` | (950, 70) | Top right |
| Back Button | `content-desc="Back"` | (70, 70) | Top left |

---

## 5) Workflows (With Approval Gates)

### Workflow 1: Post Tweet

**Preconditions:**
- Twitter app is open on DROID
- Controller has drafted tweet text
- Human approval obtained via Telegram

**Steps:**
```bash
# 1. Open Twitter (if not already)
adb -s O1E1XT232303000 shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1
sleep 3

# 2. Tap compose button
adb -s O1E1XT232303000 shell input tap 920 1800
sleep 2

# 3. Type tweet (URL-encoded)
adb -s O1E1XT232303000 shell input text "<URL_ENCODED_TWEET_TEXT>"
sleep 1

# 4. Tap Post button
adb -s O1E1XT232303000 shell input tap 950 70
sleep 3

# 5. Verify (screenshot)
adb -s O1E1XT232303000 shell screencap -p /data/local/tmp/verify_post.png
adb -s O1E1XT232303000 pull /data/local/tmp/verify_post.png /tmp/verify_post.png
```

**Approval Gate:** Before step 4 (Post), send draft to Telegram for human approval.

**Verification:** Screenshot of timeline showing posted tweet.

**Logging:**
```json
{
  "timestamp": "2026-02-11T15:30:00Z",
  "action": "post_tweet",
  "draft": "<tweet_text>",
  "approved_by": "<user>",
  "result": "success|failed",
  "screenshot_path": "/tmp/verify_post.png"
}
```

### Workflow 2: Reply to Tweet

**Preconditions:**
- Target tweet URL is known
- Draft reply is prepared
- Human approval obtained

**Steps:**
```bash
# 1. Open specific tweet
adb -s O1E1XT232303000 shell am start -a android.intent.action.VIEW \
  -d "https://twitter.com/<user>/status/<tweet_id>" com.twitter.android
sleep 4

# 2. Tap reply button
adb -s O1E1XT232303000 shell input tap 140 800
sleep 2

# 3. Type reply
adb -s O1E1XT232303000 shell input text "<URL_ENCODED_REPLY>"
sleep 1

# 4. Tap Post reply
adb -s O1E1XT232303000 shell input tap 950 70
sleep 3

# 5. Verify
adb -s O1E1XT232303000 shell screencap -p /data/local/tmp/verify_reply.png
adb -s O1E1XT232303000 pull /data/local/tmp/verify_reply.png /tmp/verify_reply.png
```

### Workflow 3: Send DM

**Preconditions:**
- Recipient username known
- Message drafted
- Human approval obtained

**Steps:**
```bash
# 1. Open Twitter
adb -s O1E1XT232303000 shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1
sleep 3

# 2. Tap Messages tab
adb -s O1E1XT232303000 shell input tap 810 2100
sleep 2

# 3. Tap New Message (if needed)
# [UI element TBD from XML dump]

# 4. Search for user, select, type message, send
# [Detailed steps TBD from XML dump]
```

---

## 6) Safety Rules

### Rate Limits & Cool-downs
- **Max 5 tweets per hour** (avoid bot-like cadence)
- **Min 30 seconds between actions** (human-like timing)
- **Randomize delays** (±10 seconds) to avoid pattern detection

### Forbidden Actions
- Mass follows/unfollows (>50 per day)
- Repetitive identical content (spam)
- Automated liking of unrelated content
- Following private accounts without verification

### Escalation Categories (Always Manual)
- Political content
- Financial advice
- Medical/health claims
- Legal matters
- Account security issues

### Emergency Stop Procedure
```bash
# Kill Twitter app immediately
adb -s O1E1XT232303000 shell am force-stop com.twitter.android

# Disconnect ADB if needed
adb disconnect
```

---

## 7) Troubleshooting

### Issue: Keyboard Not Opening
**Fix:** Tap text field again, or check if floating keyboard is enabled.
```bash
adb -s O1E1XT232303000 shell input tap 540 600  # Retap text field
```

### Issue: Popups/Permissions Blocking UI
**Fix:** Screenshot to identify popup, tap dismiss button.
```bash
adb -s O1E1XT232303000 shell input tap 540 1425  # Common "Got it" location
```

### Issue: Selector Drift After App Update
**Fix:** Re-run UIAutomator dump, update selectors in this guide.
```bash
adb -s O1E1XT232303000 shell uiautomator dump /data/local/tmp/new_dump.xml
adb -s O1E1XT232303000 pull /data/local/tmp/new_dump.xml /tmp/new_dump.xml
grep -i "compose\|post\|tweet" /tmp/new_dump.xml  # Find new selectors
```

### Issue: ADB Disconnect / Pairing Issues
**Fix:** Re-enable USB debugging, re-pair device.
```bash
# On DROID: Settings > Developer Options > Revoke USB debugging authorizations
# Reconnect USB, accept prompt
adb devices  # Verify
```

### Issue: Rate-Limit Warnings / Lockouts
**Fix:** Immediate cool-down. Check Twitter notifications for specific limits.
```bash
# Stop all automation, wait 1-24 hours depending on severity
adb -s O1E1XT232303000 shell am force-stop com.twitter.android
```

---

## 8) Audit & Logging

### Per-Action Log Entry
```json
{
  "timestamp": "2026-02-11T15:30:00Z",
  "action_type": "post_tweet|reply_to_tweet|send_dm",
  "target": {
    "tweet_id": "<id>",
    "username": "<user>",
    "platform": "twitter"
  },
  "draft": {
    "text": "<draft_content>",
    "intent": "engagement|reply|dm"
  },
  "approval": {
    "approved_by": "<telegram_user>",
    "approved_at": "2026-02-11T15:29:00Z"
  },
  "execution": {
    "device": "O1E1XT232303000",
    "method": "adb_uiautomator",
    "result": "success|failed|timeout"
  },
  "verification": {
    "screenshot_before": "/tmp/before_<id>.png",
    "screenshot_after": "/tmp/after_<id>.png",
    "xml_dump": "/tmp/dump_<id>.xml"
  },
  "error": {
    "code": "<error_code>",
    "message": "<error_message>"
  }
}
```

### Log Storage
- **Local:** `~/.openclaw/workspace/logs/droid_twitter/<YYYY-MM-DD>.jsonl`
- **Backup:** Sync to AWS S3 (if configured)

---

## Quickstart (Minimum Commands to Validate)

```bash
# 1. Validate ADB connection
adb devices

# 2. Take first screenshot
adb -s O1E1XT232303000 shell screencap -p /data/local/tmp/screen.png
adb -s O1E1XT232303000 pull /data/local/tmp/screen.png /tmp/screen.png

# 3. Dump UI hierarchy
adb -s O1E1XT232303000 shell uiautomator dump /data/local/tmp/window_dump.xml
adb -s O1E1XT232303000 pull /data/local/tmp/window_dump.xml /tmp/window_dump.xml

# 4. Open Twitter
adb -s O1E1XT232303000 shell monkey -p com.twitter.android -c android.intent.category.LAUNCHER 1
```

**Status:** ✅ Phase 0 & Phase 1 Complete
**Next:** Phase 2 — UI Mapping for Compose/Reply/DM screens

---

*Generated by CLAW on Feb 11, 2026*
