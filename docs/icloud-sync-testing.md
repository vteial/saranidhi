[← Back to Root](../README.md)

# Saranidhi — iCloud Sync Multi-Device Testing Guide

---

## Overview

Sprint 16 introduces record-level iCloud sync via CloudKit. This document describes how to verify sync works correctly across multiple Apple devices sharing the same iCloud account.

---

## Architecture

```
iPhone SE ←→ CloudKit Private DB ←→ iMac (macOS)
                    ↕
              iPad Mini (iOS)
```

- **Sync trigger:** On app open + on resume + on pull-to-refresh
- **Push trigger:** After each journal entry, profile update
- **Conflict resolution:** Primary device wins (configurable per device)
- **CloudKit container:** `iCloud.com.vteial.saranidhi`
- **Database scope:** Private (user's own data only)

---

## Prerequisites

| Item | Required |
|------|----------|
| Apple Developer account | Yes (for CloudKit container) |
| Same Apple ID on all devices | Yes |
| iCloud enabled on all devices | Yes |
| CloudKit Dashboard access | Yes (developer.apple.com/icloud) |
| Test devices | 2+ Apple devices (iPhone, iPad, Mac) |

---

## CloudKit Container Setup (One-Time)

1. Open [CloudKit Dashboard](https://icloud.developer.apple.com/)
2. Select container: `iCloud.com.vteial.saranidhi`
3. Record types auto-create on first save, but verify:
   - `Profile` — user preferences and profile data
   - `JournalEntry` — breath journal entries
   - `BreathSession` — detailed breath session recordings
   - `SyncMetadata` — device registration for conflict resolution
4. Add required indexes for each record type:
   - `recordName` → QUERYABLE
   - `createdTimestamp` → SORTABLE
5. Deploy schema changes to Production before release

---

## Test Scenarios

### Scenario 1: Initial Sync (iPhone → iCloud)

| Step | Action | Expected |
|------|--------|----------|
| 1 | Install app on iPhone, complete onboarding | Profile saved locally |
| 2 | Settings → Storage → select "iCloud" | Mode switches |
| 3 | Settings → iCloud Sync → toggle "Primary device" ON | Device is primary |
| 4 | Tap "Sync Now" | Status shows "Synced just now" |
| 5 | CloudKit Dashboard → Private DB → Profile records | Record exists |

### Scenario 2: Second Device Pulls (iMac ← iCloud)

| Step | Action | Expected |
|------|--------|----------|
| 1 | Install app on iMac, complete onboarding | Local profile created |
| 2 | Settings → Storage → select "iCloud" | Sync-on-open fires |
| 3 | Home dashboard loads | Shows journal data from iPhone |
| 4 | Settings → iCloud Sync | Shows "Other Devices: iPhone (Primary)" |

### Scenario 3: Real-Time Push (iPhone → iMac)

| Step | Action | Expected |
|------|--------|----------|
| 1 | iPhone: Log a breath entry (Solar/Right nostril) | Entry saved + pushed |
| 2 | iMac: Pull-to-refresh on Home | New entry appears |
| 3 | Verify entry details match on both devices | Timestamps, flow, alignment identical |

### Scenario 4: Conflict Resolution (Primary Wins)

| Step | Action | Expected |
|------|--------|----------|
| 1 | iPhone (PRIMARY): Change theme to "Emerald" | Push to CK |
| 2 | iMac (SECONDARY): Change theme to "Gold" locally | Local only |
| 3 | iMac: Tap "Sync Now" | Theme reverts to "Emerald" |

### Scenario 5: Primary Device Switch

| Step | Action | Expected |
|------|--------|----------|
| 1 | iPhone: Toggle primary OFF | Now secondary |
| 2 | iMac: Toggle primary ON | Now primary |
| 3 | iMac: Update display name | Pushed to CK |
| 4 | iPhone: Sync | Name updates from iMac |

### Scenario 6: Offline + Reconnect

| Step | Action | Expected |
|------|--------|----------|
| 1 | iPhone: Enable Airplane Mode | No network |
| 2 | Log 3 breath entries | Saved locally |
| 3 | Disable Airplane Mode | Network restored |
| 4 | Open app (or pull-to-refresh) | 3 entries pushed to CK |
| 5 | iMac: Sync | 3 new entries appear |

### Scenario 7: Fresh Install Restore

| Step | Action | Expected |
|------|--------|----------|
| 1 | Delete app from iMac | Local data gone |
| 2 | Reinstall, complete onboarding, select iCloud | Sync fires |
| 3 | All journal entries + profile restored from CK | Data intact |

---

## Verification Checklist

- [ ] Profile syncs bidirectionally between 2+ devices
- [ ] Journal entries appear on all devices after sync
- [ ] Primary device designation persists across restarts
- [ ] Conflict resolution respects primary device
- [ ] Offline entries sync after reconnection
- [ ] Fresh install pulls all existing CloudKit data
- [ ] Sync status UI shows correct state
- [ ] Device list shows all registered devices
- [ ] No data loss during sync (entry count matches)
- [ ] Sync is no-op on web platform (graceful skip)
- [ ] macOS target builds and runs
- [ ] macOS CloudKit entitlements work identically to iOS

---

## Known Limitations

| Limitation | Workaround |
|-----------|-----------|
| CloudKit has no real-time push notifications in our architecture | Sync fires on app open/resume/manual |
| Large datasets may be slow to sync | Pagination planned for future sprints |
| No encryption at rest in CloudKit | Data is in user's private DB (Apple-secured) |
| Cannot test without real Apple devices | Unit tests cover logic; integration requires hardware |

---

## Build Verification Commands

```bash
# Generate macOS Xcode project (first time only)
flutter create --platforms=macos .

# Build macOS app
flutter build macos

# Run on macOS
flutter run -d macos

# Build iOS
flutter build ios --simulator

# Run on iOS simulator
flutter run -d iPhone
```

---

[← Back to Root](../README.md)
