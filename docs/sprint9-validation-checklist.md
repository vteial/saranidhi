# Sprint 9 Validation Checklist

Preview: https://saranidhi-git-feature-sprint9-i18n-p-81b62b-eialarasus-projects.vercel.app

---

## Task 9.1 + 9.2: i18n & Language Switcher

- [ ] Settings → Language section shows EN/TA segmented button
- [ ] Default language is English — all labels in English
- [ ] Switch to Tamil → all UI updates immediately:
  - [ ] Bottom nav: முகப்பு / பதிவேடு / அமைப்புகள்
  - [ ] App bar titles change to Tamil
  - [ ] Settings labels (Appearance, Notifications, etc.) in Tamil
- [ ] Switch back to English → everything reverts
- [ ] Kill/reload app → language preference persists

## Task 9.3: Smooth Page Transitions

- [ ] Tap between Home / Journal / Settings tabs
- [ ] Observe smooth fade-through transition (250ms) — no harsh cut
- [ ] Onboarding screen (if triggered) slides up from bottom

## Task 9.4: Pull-to-Refresh on Home

- [ ] On Home dashboard, pull down from top
- [ ] RefreshIndicator spinner appears
- [ ] Dashboard data reloads (streak, astro info, wisdom card refresh)
- [ ] Works even when content fills the screen

## Task 9.5: Clear All Data

- [ ] Settings → scroll to bottom → "Clear All Data" in red
- [ ] Tap → confirmation dialog appears with warning message
- [ ] Tap "Cancel" → nothing happens, dialog closes
- [ ] Tap "Clear Data" → all data deleted, snackbar confirms
- [ ] App returns to onboarding (profile is gone)

## Task 9.6: Bird Emoji/Icons

- [ ] Home dashboard → Astro Info Bar shows bird emoji (🦅/🦉/🐦/🐓/🦚) with bird name + state
- [ ] Settings → Profile card shows bird emoji next to birth star/bird info

## Task 9.7: Accessibility

- [ ] Increase phone/browser font size → text scales proportionally, no overflow
- [ ] All interactive elements have adequate touch targets (no tiny tap areas)
- [ ] Screen reader (if available): Astro Info Bar has semantic label with sunrise/sunset/bird info

## Task 9.8: App Icon & Logo

- [ ] Browser tab shows app title "Saranidhi"
- [ ] Logo SVG renders in app bar (wide screens: logo + title, narrow: logo as leading icon)

---

## Quick Smoke Test Flow

1. [ ] **Fresh load** → Check English is default
2. [ ] **Switch to Tamil** → Verify all 3 tabs translate
3. [ ] **Navigate tabs** → Verify smooth transitions
4. [ ] **Pull-to-refresh** on Home → Spinner + reload
5. [ ] **Switch back to English** → Verify revert
6. [ ] **Settings → Clear All Data** → Confirm dialog → Clear → Onboarding appears
7. [ ] **Complete onboarding** → Verify bird emoji on Home + Profile
