# AG-02: SecurityAgent 🔒

## Mission
Security hardening and vulnerability scanning for CloudShell SSH client.

## Rules
- Branch: `security/agent-02-hardening`
- NEVER weaken existing security
- Document all findings in `review/SECURITY-AUDIT.md`
- Commit: `security(AG-02): SC-XXX — description`
- **AFTER EACH TASK:** Run `python3 agents/update-progress.py TASK-ID done AG-02`

---

## Task SC-001 [CRITICAL] — Audit SSH key storage security (3h)
**Files:** `lib/services/crypto/`, `lib/services/ssh/ssh_key_service.dart`
Checklist:
- [ ] Verify SSH private keys use SecureStorage (AES-256-GCM encrypted Drift DB)
- [ ] Verify keys are NEVER logged
- [ ] Verify keys excluded from device backups (NSExcludeFromBackup on iOS)
- [ ] Verify keys cleared on logout/vault lock
- [ ] Check clipboard — keys never copied without warning
- [ ] Verify PPK import doesn't leak key material

## Task SC-003 [HIGH] — Run Semgrep security scan (1h)
```bash
semgrep --config=auto lib/ --output=review/semgrep-auto.json --json
semgrep --config=p/secrets . --output=review/semgrep-secrets.json --json
```

## Task SC-004 [HIGH] — Input validation audit (2h)
- [ ] Hostname validation (RFC 952/1123)
- [ ] Port validation (1-65535)
- [ ] Username — no shell metacharacters
- [ ] SFTP paths — no path traversal (../../)
- [ ] Snippet variables — sanitize substituted values

## Task SC-005 [HIGH] — Network security audit (2h)
- [ ] iOS: App Transport Security configured
- [ ] Android: Network Security Config, cleartext disabled
- [ ] macOS: App Sandbox, minimal entitlements
- [ ] No http:// in lib/ (only localhost)

## Task SC-006 [MEDIUM] — Dependency CVE scan (1h)
Cross-reference all deps with known CVEs.

## Task SC-002 [LOW] — Add PBKDF2 comment (0.5h)
Document 1-iteration rationale in vault_crypto_service.dart:357

## Task SC-007 [MEDIUM] — Document security trade-offs (1h)
Update SECURITY.md with PBKDF2 rationale, TOFU trade-off, SecureStorage impl.