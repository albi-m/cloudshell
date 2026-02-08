# Security Hardening Report

## Overview

This document records all security measures implemented in CloudShell, the security audit findings, and the hardening actions taken. It serves as a living reference for the project's security posture.

---

## Encryption at Rest

### Database Encryption (SQLCipher)

| Property | Value |
|----------|-------|
| Algorithm | AES-256-CBC (SQLCipher default) |
| KDF Iterations | 256,000 (SQLCipher 4 default) |
| Key Storage | Platform keychain (iOS Keychain / Android Keystore / macOS Keychain / Windows DPAPI) |
| Key Size | 256-bit (32 bytes, generated via `Random.secure()`) |
| Key Generation | First-launch auto-generation, stored in `flutter_secure_storage` |
| Journal Mode | WAL (Write-Ahead Logging) for read concurrency |
| Foreign Keys | Enforced via `PRAGMA foreign_keys = ON` |

**Implementation**: `lib/data/database/app_database.dart`

The database encryption key is generated on first launch using Dart's `Random.secure()` CSPRNG and stored in the platform keychain under `cloudshell_db_encryption_key`. The key never leaves the keychain — it is only read into memory briefly during database initialization.

### Secure Storage (Platform Keychain)

| Platform | Backend | Configuration |
|----------|---------|---------------|
| iOS | Keychain Services | `first_unlock_this_device` accessibility |
| macOS | Keychain Services | `first_unlock_this_device` accessibility |
| Android | EncryptedSharedPreferences (AES-256-GCM) | Hardware-backed when available |
| Windows | DPAPI | User-level encryption |

**What is stored in the keychain:**
- SSH private keys (PEM format)
- SSH key passphrases
- Host connection passwords
- Database encryption key
- Future: Master password salt, encrypted master key, MAC key

**Implementation**: `lib/services/crypto/secure_storage.dart`

---

## SSH Security

### Host Key Verification (TOFU)

CloudShell implements Trust-On-First-Use (TOFU) host key verification:

1. **First Connection** — User is shown the server's fingerprint and asked to trust/reject
2. **Trusted Host** — Fingerprint is compared against `known_hosts` database; connection proceeds silently if matched
3. **Changed Key** — RED WARNING shown to user indicating possible MITM attack; user must explicitly choose "Trust Anyway"

**Fingerprint Format**: `SHA256:<base64-encoded-sha256-hash>` (same as OpenSSH)

**Implementation**: `lib/services/ssh/ssh_service.dart` (`_verifyHostKey` method)

### Connection Security

| Measure | Implementation |
|---------|---------------|
| Max concurrent connections | 10 (prevents resource exhaustion) |
| Connection timeout | 30 seconds (configurable) |
| Keep-alive | 60 seconds interval |
| Session idempotent close | `SshSessionWrapper.close()` is safe to call multiple times |
| Password handling | Passwords read from keychain just before connection, never cached |

### SSH Key Management

| Property | Value |
|----------|-------|
| Key Import | PEM format via `SSHKeyPair.fromPem()` |
| Supported Types | Ed25519, RSA, ECDSA |
| Private Key Storage | Platform keychain only — never in database |
| Public Key Format | OpenSSH `authorized_keys` format |
| Fingerprint | SHA256 computed via PointyCastle |
| Passphrase Storage | Platform keychain (separate key from private key) |

**Implementation**: `lib/services/ssh/ssh_key_service.dart`

---

## Data Protection

### Clipboard Security

All clipboard operations use auto-clear after 30 seconds:

- Host key fingerprints — auto-cleared
- SSH public keys — auto-cleared

**Implementation**: `lib/core/utils/clipboard_helper.dart`

The `copyWithAutoClear()` function copies text to the clipboard and schedules a `Timer` to clear it after `AppConstants.defaultClipboardTimeout` (30 seconds). The UI shows "(auto-clears in 30s)" in the SnackBar.

### Error Message Sanitization

**User-facing messages**: Generic, actionable guidance (no hostnames, IPs, or usernames).

| Exception | User Message |
|-----------|-------------|
| SshAuthException | "Authentication failed. Check your credentials and try again." |
| SshTimeoutException | "Connection timed out. Verify the server address and port." |
| SshHostKeyException | "Host key verification failed. The server identity could not be verified." |
| SshException | "SSH connection error. Please try again." |

**Log messages**: Redacted — no hostnames, usernames, or IP addresses logged.

**Implementation**: `lib/core/errors/error_handler.dart`

### Logging Security

- Debug mode: Full stack traces with 2-method context
- Release mode: Warning level only, no stack traces, no sensitive data
- No hostnames, usernames, or IP addresses in any log message
- Logger silenced in release builds (`Level.warning`)

---

## Performance Optimizations

### Database Indexes

Added Drift `@TableIndex` annotations for O(1) lookups:

**Hosts table** (`lib/data/database/tables/hosts_table.dart`):
- `idx_hosts_is_deleted` — fast active-host filtering
- `idx_hosts_group` — composite for group queries
- `idx_hosts_last_connected` — sorting by recent connections
- `idx_hosts_favorite` — favorites filtering

**Known Hosts table** (`lib/data/database/tables/known_hosts_table.dart`):
- `idx_known_hosts_lookup` — composite for hostname:port TOFU lookups

### Memory Management

| Measure | Implementation |
|---------|---------------|
| Stream subscription disposal | `_outputSubscription?.cancel()` in `TerminalScreen.dispose()` |
| Idempotent session close | `SshSessionWrapper.close()` guards with `_isClosed` flag |
| Connection counting | `_activeConnections` counter in SshService, decremented on close/error |
| Fire-and-forget DB writes | `unawaited()` for lastConnected and lastSeen updates |
| Terminal scrollback | Bounded to 10,000 lines via `AppConstants.defaultScrollbackLines` |

### Resource Limits

| Resource | Limit | Implementation |
|----------|-------|---------------|
| SSH connections | 10 max concurrent | `_maxConcurrentConnections` in ssh_service.dart |
| Terminal scrollback | 10,000 lines | `AppConstants.defaultScrollbackLines` |
| Connection timeout | 30 seconds | `AppConstants.defaultConnectionTimeout` |
| Clipboard exposure | 30 seconds | `AppConstants.defaultClipboardTimeout` |

---

## Security Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│                    UI Layer                      │
│  (Forms, Terminal, Dialogs — no secrets here)    │
├─────────────────────────────────────────────────┤
│                 Service Layer                    │
│  SshService ──→ SshKeyService ──→ SecureStorage  │
│       │              │                  │        │
│  ┌────▼────┐   ┌─────▼─────┐   ┌───────▼──────┐ │
│  │dartssh2 │   │PointyCastle│   │flutter_secure│ │
│  │(SSH/SFTP)│   │ (SHA256)  │   │  _storage    │ │
│  └─────────┘   └───────────┘   └──────────────┘ │
├─────────────────────────────────────────────────┤
│                  Data Layer                      │
│  ┌────────────────┐   ┌───────────────────────┐ │
│  │ Drift Database  │   │  Platform Keychain    │ │
│  │ (SQLCipher AES) │   │  (OS-level encrypt)  │ │
│  │ 256-bit key ────┼───│  Stores: DB key,      │ │
│  │ WAL mode        │   │  SSH keys, passwords  │ │
│  └────────────────┘   └───────────────────────┘ │
└─────────────────────────────────────────────────┘
```

---

## Remaining Work (Phase 2+)

### Master Password & Vault Encryption
- Argon2id KDF (64 MB memory, 3 iterations, 4 parallelism)
- AES-256-GCM per-item encryption
- HKDF-SHA256 for MAC key derivation
- Constants defined in `app_constants.dart`, not yet implemented

### Biometric Authentication
- `local_auth` package in pubspec.yaml
- Settings UI toggle exists (currently non-functional)
- Requires master password flow first

### Auto-Lock
- `defaultAutoLockSeconds` (300s) defined
- `lastUnlockTimestamp` storage key reserved
- Implementation deferred to Phase 3

### HMAC Verification
- `macKey` storage key reserved
- Will authenticate keychain entries after master password is implemented

---

## Audit History

| Date | Action | Files Changed |
|------|--------|---------------|
| 2026-02-08 | Initial security audit | All lib/ files |
| 2026-02-08 | SQLCipher database encryption | `app_database.dart` |
| 2026-02-08 | Full TOFU host key verification | `ssh_service.dart` |
| 2026-02-08 | Connection limit (10 max) | `ssh_service.dart` |
| 2026-02-08 | Sanitized error messages | `error_handler.dart`, `ssh_service.dart` |
| 2026-02-08 | Clipboard auto-clear | `clipboard_helper.dart`, `host_key_verify_dialog.dart`, `keys_screen.dart` |
| 2026-02-08 | Stream leak fix in terminal | `terminal_screen.dart` |
| 2026-02-08 | Idempotent session close | `ssh_session.dart` |
| 2026-02-08 | Database indexes added | `hosts_table.dart`, `known_hosts_table.dart` |
| 2026-02-08 | Secure logging (release mode) | `error_handler.dart` |
