# CloudShell Security Audit Report

**Agent:** AG-02 SecurityAgent
**Date:** 2026-02-25
**Branch:** `security/agent-02-hardening`
**Scope:** Full security hardening audit of CloudShell SSH client

---

## Executive Summary

CloudShell has a **strong security posture** for an open-source SSH client. The audit found **no critical vulnerabilities** — only hardening improvements. All fixes have been applied.

| Category | Status | Findings |
|----------|--------|----------|
| SSH Key Storage (SC-001) | PASS | Keys properly encrypted (AES-256-GCM), never logged |
| PBKDF2 Rationale (SC-002) | PASS | Documentation added |
| Semgrep Scan (SC-003) | PASS | 0 findings (auto + secrets) |
| Input Validation (SC-004) | HARDENED | Username + SFTP path validation improved |
| Network Security (SC-005) | PASS | ATS, sandbox, no cleartext HTTP |
| Dependency CVEs (SC-006) | LOW RISK | No active CVEs, Terrapin advisory noted |
| Documentation (SC-007) | UPDATED | SECURITY.md expanded |

---

## SC-001: SSH Key Storage Audit

### What Was Checked
- `lib/services/crypto/secure_storage.dart` — SecureStorageService
- `lib/services/ssh/ssh_key_service.dart` — SshKeyService
- `lib/services/crypto/app_crypto_service.dart` — AppCryptoService
- `lib/services/crypto/vault_crypto_service.dart` — VaultCryptoService
- `lib/services/ssh/ppk_parser.dart` — PpkParser

### Findings

| Check | Result | Notes |
|-------|--------|-------|
| SSH keys use SecureStorage | PASS | AES-256-GCM encrypted via AppCryptoService |
| Keys never logged | PASS | All `_log.d()` calls exclude key material |
| Keys excluded from backups | FIXED | Android: added `allowBackup=false` |
| Keys cleared on vault lock | PASS | VaultKeys.destroy() wipes all key material |
| Clipboard safety | FIXED | TOTP secret now uses copyWithAutoClear() |
| PPK import doesn't leak keys | PASS | Converted PEM stays in memory only |

### Fixes Applied
1. **TOTP clipboard** (`lib/ui/auth/totp_setup_screen.dart:240`): Changed `Clipboard.setData()` to `copyWithAutoClear()` with automatic clipboard clearing after timeout.
2. **Android backup** (`android/app/src/main/AndroidManifest.xml`): Added `android:allowBackup="false"` and `android:fullBackupContent="false"` to prevent sensitive data leaking through device backups.

### Architecture Assessment
The encryption architecture is well-designed:
- **Local secrets**: Machine-bound AES-256-GCM with PBKDF2-SHA256 (100k iterations) key from hardware UUID
- **Vault secrets**: Argon2id (64 MB / 3 iter / 4 parallelism) → HKDF-SHA256 → per-item AES-256-GCM with HMAC-SHA256 authentication
- **Constant-time HMAC comparison** prevents timing attacks
- **VaultKeys.destroy()** properly wipes key material from memory

---

## SC-002: PBKDF2 1-Iteration Rationale

**File:** `lib/services/crypto/vault_crypto_service.dart:355-371`

Added expanded documentation explaining why `computeAuthHash()` uses PBKDF2 with iterations=1. The masterKey has already been through Argon2id (64 MB / 3 iterations / 4 parallelism), so this PBKDF2 pass is not for key-stretching — it produces a one-way transformation safe to send to the server. This follows the Bitwarden model.

---

## SC-003: Semgrep Security Scan

### Scans Executed
```bash
semgrep --config=auto lib/          # General security rules
semgrep --config=p/secrets .        # Secret detection
```

### Results
- **Auto scan:** 0 findings
- **Secrets scan:** 0 findings

Raw JSON results saved to `review/semgrep-auto.json` and `review/semgrep-secrets.json`.

---

## SC-004: Input Validation Audit

### Hostname Validation — PASS
- `Validators.hostname()` delegates to `isValidSshHost`
- `isValidSshHost` checks IPv4 (octet range), IPv6 (regex), and RFC 1123 hostname
- Quick connect dialog properly parses `user@host:port` format with range checks

### Port Validation — PASS
- `Validators.port()` enforces 1-65535 range
- `int.tryParse()` handles non-numeric input safely

### Username Validation — HARDENED
- Added shell metacharacter rejection: `;&|`$(){}\\<>!#`
- Added 64-character length limit
- Existing space rejection preserved

### SFTP Path Traversal — HARDENED
- Added `SftpService.normalizePath()` that rejects `../` traversal
- Applied to `listDirectory()` entry path construction
- Note: Remote server enforces ultimate access control; client-side normalization prevents accidental traversal

### Snippet Variables — ACCEPTED RISK
Snippet variable substitution performs naive string replacement without shell escaping. This is **by design** — snippets are user-authored commands sent to their own SSH terminals. Shell metacharacters in variable values would only affect the user's own session. Documenting this as an accepted trade-off rather than a vulnerability.

---

## SC-005: Network Security Audit

| Platform | Check | Status |
|----------|-------|--------|
| iOS | App Transport Security | PASS — ATS enabled by default, no exceptions declared |
| iOS | Privacy manifest | PASS — NSPrivacyTracking=false, no data collection |
| Android | Network security | PASS — Only INTERNET permission, no cleartext |
| Android | Backup prevention | FIXED — `allowBackup=false` added (SC-001) |
| macOS | App Sandbox (Release) | PASS — Sandbox enabled with minimal entitlements |
| macOS | App Sandbox (Debug) | PASS — Sandbox disabled for development (expected) |
| All | Cleartext HTTP | PASS — Zero `http://` URLs in lib/ (excluding localhost) |
| macOS | Entitlements | PASS — network.client, network.server, files.user-selected.read-write |

---

## SC-006: Dependency CVE Scan

### Critical Dependencies

| Package | Version | CVE Status |
|---------|---------|------------|
| dartssh2 | 2.9.0 | Advisory: CVE-2023-48795 (Terrapin) may apply |
| cryptography | 2.7.0 | No known CVEs |
| pointycastle | 3.9.1 | No known CVEs; timing attack mitigations in place |
| flutter_secure_storage | 9.2.4 | Low: metadata exposure on rooted Android devices |
| sqlite3_flutter_libs | 0.5.41 | No known CVEs for bundled SQLite version |

### CVE-2023-48795 (Terrapin Attack)
- **Severity:** Medium
- **Impact:** Potential SSH protocol downgrade via man-in-the-middle
- **Mitigation:** Requires MITM position; modern SSH servers (OpenSSH 9.5+) implement "strict kex" countermeasure
- **Recommendation:** Monitor dartssh2 for Terrapin mitigation updates; consider documenting this in user-facing security docs

### flutter_secure_storage Metadata Exposure
- **Severity:** Low
- **Impact:** Key names visible in `FlutterSecureKeyStorage.xml` on rooted Android
- **Mitigation:** CloudShell uses its own `AppCryptoService` + Drift DB for primary secret storage, not flutter_secure_storage directly for SSH keys. The app's custom encryption layer provides defense-in-depth.

---

## SC-007: Security Trade-offs

### Documented Trade-offs

1. **TOFU (Trust On First Use) for Host Keys**
   - First connection trusts the server's host key without external verification
   - Subsequent connections verify against stored key
   - Trade-off: Usability vs. security (SSH standard practice)

2. **Machine-Bound Encryption Key**
   - Local secrets encrypted with key derived from hardware UUID
   - Means secrets can't be moved between devices
   - Trade-off: Portability vs. device-binding security

3. **Snippet Variable Substitution**
   - No shell escaping on substituted variables
   - Users control their own snippets and variable values
   - Trade-off: Flexibility vs. accidental shell injection (self-only risk)

4. **PBKDF2 Auth Hash (1 iteration)**
   - Input already derived from Argon2id
   - PBKDF2 is for one-way transformation, not stretching
   - Trade-off: Follows Bitwarden model, documented in code

5. **Debug Build Reduced Argon2id**
   - Debug: 1 MB / 1 iteration (for development speed)
   - Release: 64 MB / 3 iterations (production security)
   - Trade-off: Development velocity vs. consistent testing

---

## Recommendations

### Immediate (Done)
- [x] Fix TOTP clipboard auto-clear
- [x] Add Android backup prevention
- [x] Harden username validation
- [x] Add SFTP path normalization
- [x] Document PBKDF2 rationale

### Future Sprints
- [ ] Monitor dartssh2 for CVE-2023-48795 (Terrapin) mitigation
- [ ] Consider upgrading flutter_secure_storage to 10.x when doing dependency sprint
- [ ] Add `NSExcludeFromBackup` attribute to iOS database directory
- [ ] Consider certificate pinning for future Supabase sync endpoints
