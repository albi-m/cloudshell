# AG-01: BugFixer Agent 🐛

## Mission
Fix all critical bugs identified in ANALYSIS-REPORT.md and quality audit.

## Rules
- Create a git branch: `fix/agent-01-bugs`
- Write a test BEFORE fixing each bug (TDD)
- Run `flutter analyze` after each fix
- Commit after each task with message: `fix(AG-01): BF-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-01`
  - When starting a task: `python3 agents/update-progress.py BF-001 in-progress AG-01`
  - When done: `python3 agents/update-progress.py BF-001 done AG-01`

---

## Task BF-001 [CRITICAL] — Fix biometric lock grace period
**Files:** `lib/app.dart`, `lib/providers/app_lock_provider.dart`, `lib/providers/settings_provider.dart`
**Estimate:** 2h

### Problem
App locks INSTANTLY on any background event (notification center, app switch, phone call).
`didChangeAppLifecycleState` calls `lock()` immediately on `paused` or `hidden`.

### Fix
1. In `AppLockNotifier` (app_lock_provider.dart):
   - Add `Timer? _lockTimer`
   - Add `scheduleLock(Duration gracePeriod)` — starts timer, calls lock() when it fires
   - Add `cancelScheduledLock()` — cancels timer if user returns before it fires

2. In `app.dart` `didChangeAppLifecycleState`:
   - On `paused`/`hidden`: call `scheduleLock()` instead of `lock()`
   - On `resumed`: call `cancelScheduledLock()`

3. In `settings_provider.dart`:
   - Add `appLockGracePeriod` setting (options: 0s, 30s, 1m, 5m, 15m)

4. In Settings UI:
   - Add "Lock Timeout" dropdown in Security section

### Test First
```dart
test('should not lock if resumed within grace period', () async { ... });
test('should lock after grace period expires', () async { ... });
test('should lock immediately when grace period is 0', () async { ... });
```

---

## Task BF-002 [HIGH] — Fix silent error swallowing
**Files:** Multiple files with `catch (_) {}`
**Estimate:** 1h

### Fix
1. Search: `grep -rn "catch (_)" lib/`
2. Replace with `catch (e, stackTrace)` + proper logging
3. For user-facing errors, add proper error state handling

---

## Task BF-003 [HIGH] — Fix quickConnect auto-accepts all host keys
**Files:** `lib/services/ssh/ssh_service.dart`
**Estimate:** 1.5h

### Problem
Line ~279: `onVerifyHostKey: (_, _) => true` auto-accepts ALL host keys.

### Fix
1. Show dialog with host key fingerprint
2. Let user choose: Trust Once / Trust Always / Reject
3. If "Trust Always", save to known_hosts

---

## Task BF-004 [MEDIUM] — Rate limiting on biometric auth failures
**Depends on:** BF-001
**Estimate:** 1h

### Fix
Exponential backoff: 3 fails → 30s, 5 → 2min, 10 → 15min

---

## Task BF-005 [LOW] — Verify RadioGroup<T> widget
**Files:** `lib/ui/settings/settings_screen.dart`
**Estimate:** 0.5h

Confirm custom or from dependency. Replace if needed.