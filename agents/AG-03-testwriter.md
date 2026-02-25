# AG-03: TestWriter Agent 🧪

## Mission
Bring test coverage from ~5% to 80%+ on business logic.

## Rules
- Branch: `test/agent-03-coverage`
- Tests in `test/` mirroring `lib/` structure
- Use `flutter_test`, `mocktail` for mocking
- Commit: `test(AG-03): TW-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-03`

## Current: 7 test files / 160 source files

---

## Task TW-001 [CRITICAL] — Unit tests for VaultCryptoService (4h)
Tests: encrypt/decrypt cycle, key derivation, HMAC verification, tamper detection, wrong password

## Task TW-002 [CRITICAL] — Unit tests for AppLockNotifier (2h)
**Depends on:** BF-001
Tests: lock/unlock, grace period timer, biometric auth, rate limiting

## Task TW-003 [HIGH] — Unit tests for SshService (3h)
**Depends on:** BF-003
Tests: connect, auth types, host key verification, disconnect, max connections

## Task TW-004 [HIGH] — Unit tests for all Providers (6h)
17 providers with 0 tests. Priority: host_provider, connection_provider, terminal_tab_provider, vault_provider, sync_provider

## Task TW-005 [HIGH] — Widget tests for all screens (8h)
0 widget tests. Test: login, hosts, terminal, settings, sftp, snippets, keys (renders, interactions, error/empty states)

## Task TW-006 [MEDIUM] — Golden tests for visual regression (4h)
Setup framework. Baseline screenshots for mobile (390x844) and desktop (1440x900) viewports.

## Task TW-007 [MEDIUM] — Integration tests for critical flows (4h)
Test: Login→Connect→Terminal, SFTP browse→upload, Vault setup→encrypt→decrypt

## Task TW-008 [MEDIUM] — Achieve 80% code coverage (8h)
Run `flutter test --coverage`. Target: services 90%, providers 85%, data 80%.