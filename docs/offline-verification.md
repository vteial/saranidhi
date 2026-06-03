[← Back to Root](../README.md)

# Saranidhi — Offline Functionality Verification (Sprint 10)

## Architecture: Zero Network Dependency

Saranidhi is designed as a **local-first, offline-capable** application. All core features work without network connectivity.

---

## Offline Verification Matrix

### Core Features (Must Work Offline)

| Feature | Network Required | Offline Status | Notes |
|---------|-----------------|----------------|-------|
| Sunrise/Sunset calculation | No | ✅ Works | Pure Dart math (NOAA algorithm) |
| 5 Yamas calculation | No | ✅ Works | Derived from sunrise/sunset |
| Rahu Kaal calculation | No | ✅ Works | Derived from sunrise/sunset |
| Hora calculation | No | ✅ Works | Derived from sunrise/sunset |
| Pakshi bird state | No | ✅ Works | Weekday + lunar phase (computed) |
| Tattva cycle | No | ✅ Works | Derived from Yama |
| Lunar phase | No | ✅ Works | Pure math (synodic algorithm) |
| Breath entry logging | No | ✅ Works | Drift SQLite local storage |
| Alignment checking | No | ✅ Works | Pure Dart comparison |
| Streak calculation | No | ✅ Works | Queries local DB |
| 7-day ribbon | No | ✅ Works | Computed from local entries |
| 30-day trend | No | ✅ Works | Computed from local entries |
| AI Wisdom (fallback) | No | ✅ Works | Static proverbs library |
| AI Wisdom (rules engine) | No | ✅ Works | Deterministic rules |
| Theme switching | No | ✅ Works | SharedPreferences local |
| Language switching | No | ✅ Works | Bundled ARB translations |
| Profile edit | No | ✅ Works | Local Drift DB |
| Notifications (mobile) | No | ✅ Works | flutter_local_notifications |
| Clear All Data | No | ✅ Works | Clears local DB + prefs |

### Features Requiring Network (Graceful Degradation)

| Feature | Network Required | Offline Behavior |
|---------|-----------------|-----------------|
| Cloud backup (upload) | Yes | Shows error message, data preserved locally |
| Cloud restore (download) | Yes | Shows error message, continues with local data |
| AI Wisdom (on-device LLM download) | One-time | Falls back to rules engine / static proverbs |
| Apple/Google Sign-In | Yes | Shows error, user stays on local-only mode |

---

## Verification Steps (Manual QA)

1. [ ] Enable airplane mode on device
2. [ ] Launch app — should load normally
3. [ ] Complete onboarding — profile saves to local DB
4. [ ] Log a breath entry — saves, alignment shows
5. [ ] Navigate all tabs — no errors, no spinners
6. [ ] Change theme — applies immediately
7. [ ] Change language — switches immediately
8. [ ] Check streak — computed from local entries
9. [ ] View wisdom card — fallback proverb displays
10. [ ] Attempt cloud backup — graceful error message
11. [ ] Kill and relaunch app — all data persisted

---

## Technical Implementation

### Why It Works Offline

1. **No REST APIs** — Zero server calls for core functionality
2. **Drift SQLite** — Local database with WebAssembly support
3. **Pure Dart calculations** — All astro-logic is math, not API calls
4. **Bundled assets** — Logo, translations, wisdom library compiled into app
5. **SharedPreferences** — Settings stored locally
6. **Static wisdom library** — 60+ proverbs bundled in code

---

[← Back to Root](../README.md)
