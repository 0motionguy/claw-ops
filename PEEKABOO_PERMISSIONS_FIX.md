# 🔍 Peekaboo Permissions - Documentation Summary

**Source:** https://github.com/steipete/Peekaboo/blob/main/docs/permissions.md  
**Date:** 2026-02-08  
**Purpose:** Fix Peekaboo macOS permissions

---

## 📋 REQUIREMENTS

### System:
- **macOS 15.0+ (Sequoia)** - Required for core automation APIs

### Permissions Needed:

#### 1. **Screen Recording (REQUIRED)**
**What it enables:**
- CGWindow capture (screenshots)
- Multi-app automation
- Background captures
- Fast window enumeration

**How to grant:**
1. System Settings → Privacy & Security → Screen & System Audio Recording
2. Enable **Terminal** (or whatever runs `peekaboo`)
3. May need to restart Terminal

#### 2. **Accessibility (RECOMMENDED)**
**What it enables:**
- Window focus control
- Menu interaction
- Dialog control
- Reliable clicks/keystrokes

**How to grant:**
1. System Settings → Privacy & Security → Accessibility
2. Enable **Terminal** (or IDE running peekaboo)

---

## 🔧 COMMANDS TO FIX

### Check Current Status:
```bash
peekaboo permissions check
```

### Request Screen Recording:
```bash
peekaboo permissions request screen-recording
```

### Request Accessibility:
```bash
peekaboo permissions request accessibility
```

---

## ✅ STEP-BY-STEP FIX

### Method 1: Automatic (Try First)
```bash
# 1. Check current status
peekaboo permissions check

# 2. Request permissions
peekaboo permissions request screen-recording
peekaboo permissions request accessibility

# 3. Verify
peekaboo permissions check
```

### Method 2: Manual (If automatic fails)

**Step 1: Screen Recording**
1. Open **System Settings**
2. Go to **Privacy & Security**
3. Click **Screen & System Audio Recording**
4. Find **Terminal** in the list
5. **Toggle ON** (enable)
6. Click **Quit & Reopen** if prompted

**Step 2: Accessibility**
1. In **System Settings** → **Privacy & Security**
2. Click **Accessibility**
3. Find **Terminal** in the list
4. **Toggle ON** (enable)

**Step 3: Verify**
```bash
peekaboo permissions check
peekaboo see --annotate
```

---

## ⚠️ COMMON ISSUES

### Issue: "Permission Denied" even after enabling
**Fix:** 
- Quit Terminal completely
- Reopen Terminal
- Run `peekaboo permissions check` again

### Issue: Terminal not in the list
**Fix:**
- Run `peekaboo permissions request screen-recording` first
- This should add Terminal to the list
- Then manually enable in System Settings

### Issue: Changes don't stick
**Fix:**
- macOS may require restart after permission changes
- Or log out and log back in

---

## 🎯 QUICK TEST

After permissions granted:
```bash
# Should work without errors:
peekaboo see --annotate --path /tmp/test.png

# Should show UI elements:
peekaboo click --on "Safari"
```

---

## 💡 FOR ANDROID DEVICES (Tomorrow's Plan)

Since Basil mentioned 2 Android devices for marketing, Peekaboo could help:
- **Mirror Android screen** to Mac (via scrcpy or similar)
- **Automate Android** through screen capture + clicks
- **Monitor Android apps** visually

But first need to fix permissions!

---

## 📝 SUMMARY

**What's blocking Peekaboo:**
- ❌ Screen Recording permission (for captures)
- ❌ Accessibility permission (for clicks/typing)

**Fix:**
1. Run `peekaboo permissions request` commands
2. Or manually enable in System Settings
3. Restart Terminal
4. Verify with `peekaboo permissions check`

**Priority:** HIGH - Needed for Android automation research tomorrow

---

*Documentation extracted from official Peekaboo repo* 🦞
