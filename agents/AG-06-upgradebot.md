# AG-06: UpgradeBot Agent ⬆️

## Mission
Upgrade all outdated packages safely with test verification.

## Rules
- Branch: `upgrade/agent-06-packages`
- ONE package per commit
- Run ALL tests after each upgrade
- Commit: `deps(AG-06): UP-XXX — upgrade package X.x → Y.y`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-06`

---

## Task UP-001 [HIGH] — flutter_riverpod 2.x → 3.x (6h)
**Depends on:** TW-004 (tests must exist first)
Major API changes. Update all 17 providers. Regenerate with build_runner.

## Task UP-002 [HIGH] — go_router 14.x → 17.x (3h)
**Depends on:** TW-004
Breaking routing API. Update app_router.dart.

## Task UP-003 [MEDIUM] — dartssh2 2.9 → 2.12 (2h)
Test all SSH connection types after upgrade.

## Task UP-004 [MEDIUM] — drift 2.22 → 2.31 (2h)
Regenerate .g.dart files. Run all DAO tests.

## Task UP-005 [MEDIUM] — local_auth 2.x → 3.x (2h)
**Depends on:** BF-001 (biometric fix)
Breaking biometric API changes.

## Task UP-006 [LOW] — Remaining packages (3h)
google_fonts 6→8, share_plus 10→11, connectivity_plus 6→7, pointycastle 3→4, cryptography 2.7→2.9