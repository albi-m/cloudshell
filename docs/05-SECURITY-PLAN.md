# CloudShell - Security & Cybersecurity Plan

---

## 1. Security Philosophy

CloudShell handles the most sensitive data a developer has: SSH private keys, server passwords, and direct access to production infrastructure. A breach in our app means a breach in every server our users manage.

### Core Principles

```
1. ZERO KNOWLEDGE     — Server never sees plaintext credentials
2. DEFENSE IN DEPTH   — Multiple independent security layers
3. LEAST PRIVILEGE    — App requests only necessary permissions
4. FAIL SECURE        — On error, lock vault, drop connections
5. ASSUME BREACH      — Design so even a database leak is useless
6. OPEN BY DEFAULT    — Crypto code open-source, auditable
7. NO SILENT FAILURES — Every security event is logged and visible
```

---

## 2. Threat Model

### 2.1 Assets to Protect

```
┌────────────────────────────────────────────────────────────────────┐
│  CRITICAL ASSETS (compromise = direct server access)              │
├────────────────────────────────────────────────────────────────────┤
│  • SSH private keys (Ed25519, RSA, ECDSA)                        │
│  • Server passwords                                               │
│  • Server hostnames + ports + usernames (connection blueprints)    │
│  • Active SSH sessions (live shell access)                        │
│  • Port forwarding tunnels (network access)                       │
│  • SFTP file transfers (data in transit)                          │
├────────────────────────────────────────────────────────────────────┤
│  HIGH VALUE ASSETS                                                │
├────────────────────────────────────────────────────────────────────┤
│  • Master password hash material                                  │
│  • Vault encryption keys (in memory)                              │
│  • JWT authentication tokens                                      │
│  • Known host fingerprints (trust anchors)                        │
│  • Sync encryption salt and KDF parameters                        │
│  • User email addresses                                           │
├────────────────────────────────────────────────────────────────────┤
│  MODERATE VALUE ASSETS                                            │
├────────────────────────────────────────────────────────────────────┤
│  • Snippets (may contain secrets in commands)                     │
│  • Connection history / timestamps                                │
│  • Host group organization (reveals infrastructure topology)      │
│  • App settings and preferences                                   │
│  • Tags and labels (may reveal project names)                     │
└────────────────────────────────────────────────────────────────────┘
```

### 2.2 Threat Actors

| Actor | Motivation | Capability | Priority |
|-------|-----------|------------|----------|
| **Opportunistic attacker** | Stolen device, public WiFi | Low-medium (physical access, network sniffing) | HIGH |
| **Targeted attacker** | Specific organization's servers | Medium-high (phishing, malware, social engineering) | HIGH |
| **Malicious insider** | Our own backend access | High (database access, server logs) | CRITICAL |
| **Nation-state APT** | Espionage, infrastructure sabotage | Very high (0-days, supply chain) | MEDIUM |
| **App store supply chain** | Trojan distribution | Medium (compromised dependency) | MEDIUM |
| **Compromised sync server** | Mass credential theft | High (database dump) | CRITICAL |

### 2.3 Attack Vectors & Mitigations

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ATTACK VECTOR                    │ IMPACT  │ MITIGATION                      │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ DEVICE THEFT / LOSS              │         │                                 │
│ Attacker gets physical device    │ CRITICAL│ • Vault locked with master pw   │
│                                  │         │ • Auto-lock on app background   │
│                                  │         │ • SQLCipher encrypts DB at rest │
│                                  │         │ • Keys in platform keychain     │
│                                  │         │ • No plaintext on disk ever     │
│                                  │         │ • Remote wipe via account panel │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ NETWORK INTERCEPTION (MITM)      │         │                                 │
│ Public WiFi, DNS hijacking       │ HIGH    │ • SSH protocol inherently E2E   │
│                                  │         │ • Sync API over TLS 1.3 only    │
│                                  │         │ • Certificate pinning on sync   │
│                                  │         │ • Host key verification (TOFU)  │
│                                  │         │ • Warn on host key change       │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ SYNC SERVER BREACH               │         │                                 │
│ Database dump, backup theft      │ CRITICAL│ • E2E encryption (zero-knowledge│
│                                  │         │ • Server stores only encrypted  │
│                                  │         │   blobs, never plaintext        │
│                                  │         │ • Argon2id makes brute-force    │
│                                  │         │   infeasible (64MB memory cost) │
│                                  │         │ • Per-item encryption keys      │
│                                  │         │ • Auth hash ≠ encryption key    │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ MALICIOUS DEPENDENCY             │         │                                 │
│ Compromised pub.dev package      │ HIGH    │ • Pin exact dependency versions │
│                                  │         │ • Review changelogs on update   │
│                                  │         │ • Minimal dependency footprint  │
│                                  │         │ • Lock file committed to VCS    │
│                                  │         │ • SCA scanning in CI/CD         │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ MEMORY EXTRACTION                │         │                                 │
│ Cold boot, debugger attach       │ MEDIUM  │ • Zero memory after key use     │
│                                  │         │ • No debug builds in production │
│                                  │         │ • Obfuscation on release builds │
│                                  │         │ • Disable screenshots on mobile │
│                                  │         │   when vault is visible         │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ CLIPBOARD EXFILTRATION           │         │                                 │
│ Clipboard manager, other apps    │ MEDIUM  │ • Auto-clear clipboard (30s)    │
│                                  │         │ • Clear on app background       │
│                                  │         │ • Use iOS/Android secure paste  │
│                                  │         │   when available                │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ BRUTE FORCE (MASTER PASSWORD)    │         │                                 │
│ Offline dictionary attack        │ HIGH    │ • Argon2id with 64MB memory     │
│                                  │         │ • 3 iterations, parallelism 4   │
│                                  │         │ • Master pw strength meter      │
│                                  │         │ • Minimum 10 char requirement   │
│                                  │         │ • Lockout after 5 failed tries  │
│                                  │         │   (30s, 1m, 5m, 15m, 1h)       │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ SSH HOST IMPERSONATION           │         │                                 │
│ Fake server, DNS hijack          │ HIGH    │ • Host key fingerprint verify   │
│                                  │         │ • TOFU (Trust On First Use)     │
│                                  │         │ • BOLD warning on key change    │
│                                  │         │ • Show full fingerprint hash    │
│                                  │         │ • Known hosts DB (encrypted)    │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ SHOULDER SURFING                 │         │                                 │
│ Visual observation               │ LOW     │ • Password fields always masked │
│                                  │         │ • Key material never displayed  │
│                                  │         │ • Private key show requires     │
│                                  │         │   biometric re-auth             │
│                                  │         │ • Auto-lock on idle             │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ PHISHING (SYNC SERVER)           │         │                                 │
│ Fake sync login page             │ MEDIUM  │ • Certificate pinning           │
│                                  │         │ • Server URL visible in settings│
│                                  │         │ • No in-app browser for auth    │
│                                  │         │ • Email verification on signup  │
│                                  │         │ • 2FA (TOTP) option             │
├──────────────────────────────────┼─────────┼─────────────────────────────────┤
│ BACKUP EXPOSURE                  │         │                                 │
│ iCloud/Google backup includes    │ MEDIUM  │ • Exclude vault from OS backups │
│ app data                         │         │ • iOS: set file protection      │
│                                  │         │   completeProtection            │
│                                  │         │ • Android: android:allowBackup  │
│                                  │         │   = false (or encrypted backup) │
│                                  │         │ • Manual export is encrypted    │
└──────────────────────────────────┴─────────┴─────────────────────────────────┘
```

---

## 3. Encryption Specification

### 3.1 Cryptographic Algorithms

```
┌──────────────────────┬──────────────────────────────────────────────────────┐
│ Purpose              │ Algorithm & Parameters                              │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Key Derivation       │ Argon2id                                            │
│                      │   Memory: 64 MB                                     │
│                      │   Iterations: 3                                     │
│                      │   Parallelism: 4                                    │
│                      │   Output: 256 bits                                  │
│                      │   Salt: 128-bit random (per user, stored in vault)  │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Key Expansion        │ HKDF-SHA256                                         │
│                      │   Input: 256-bit master key                         │
│                      │   Output: 512 bits (256 enc + 256 mac)              │
│                      │   Info: "cloudshell-enc" / "cloudshell-mac"         │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Symmetric Encryption │ AES-256-GCM                                         │
│                      │   Key: 256 bits                                     │
│                      │   IV/Nonce: 96 bits (random, never reused)          │
│                      │   Auth Tag: 128 bits                                │
│                      │   AAD: entry type + entry ID (prevents swapping)    │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Authentication Hash  │ PBKDF2-SHA256                                       │
│ (for server login)   │   Input: master key (NOT master password)           │
│                      │   Iterations: 1 (already derived from Argon2id)     │
│                      │   Salt: email address (normalized, lowercase)       │
│                      │   Server stores: bcrypt(auth_hash, cost=12)         │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Per-Item Keys        │ AES-256 (random)                                    │
│                      │   Generated per vault entry                         │
│                      │   Encrypted with master EncKey                      │
│                      │   Enables future key rotation without re-encrypting │
│                      │   all items                                         │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ SSH Key Generation   │ Ed25519 (default), RSA-4096, ECDSA-P521            │
│                      │   Private key encrypted with AES-256-GCM before    │
│                      │   storage in platform keychain                      │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Random Number Gen    │ dart:math SecureRandom (maps to platform CSPRNG)    │
│                      │   iOS/macOS: SecRandomCopyBytes                     │
│                      │   Android: java.security.SecureRandom               │
│                      │   Windows: BCryptGenRandom                          │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ TLS (Sync API)       │ TLS 1.3 only                                        │
│                      │   Cipher: TLS_AES_256_GCM_SHA384                    │
│                      │   Certificate pinning (HPKP-style, in-app)          │
├──────────────────────┼──────────────────────────────────────────────────────┤
│ Password Hashing     │ bcrypt (server-side only)                           │
│ (server stores this) │   Cost factor: 12                                   │
│                      │   Input: auth_hash (NOT master password)            │
└──────────────────────┴──────────────────────────────────────────────────────┘
```

### 3.2 Key Hierarchy Diagram

```
  User's Brain
       │
  Master Password (never stored, never transmitted)
       │
       ▼
  ┌─────────────────────────────────────────────────────────┐
  │  Argon2id(password, salt, 64MB, 3 iter, 4 parallel)    │
  └──────────────────────┬──────────────────────────────────┘
                         │
                    Master Key (256-bit)
                         │
         ┌───────────────┼──────────────────┐
         ▼               ▼                  ▼
   ┌───────────┐   ┌───────────┐   ┌──────────────────┐
   │ HKDF      │   │ HKDF      │   │ PBKDF2-SHA256    │
   │ "enc"     │   │ "mac"     │   │ (1 round)        │
   │           │   │           │   │                   │
   │ EncKey    │   │ MACKey    │   │ AuthHash          │
   │ (256-bit) │   │ (256-bit) │   │ (sent to server)  │
   └─────┬─────┘   └─────┬─────┘   └──────────────────┘
         │               │                  │
         │               │           Server stores
         │               │           bcrypt(AuthHash)
         │               │
         ▼               ▼
  ┌──────────────────────────────┐
  │ Per-Item Encryption          │
  │                              │
  │ ItemKey = random AES-256     │
  │                              │
  │ EncryptedData =              │
  │   AES-GCM(ItemKey, data)     │
  │                              │
  │ EncryptedItemKey =           │
  │   AES-GCM(EncKey, ItemKey)   │
  │                              │
  │ AuthTag =                    │
  │   HMAC-SHA256(MACKey,        │
  │     EncryptedData +          │
  │     EncryptedItemKey)        │
  └──────────────────────────────┘
```

### 3.3 What the Server Knows vs Doesn't Know

```
┌────────────────────────────────────┬──────────────────────────────────┐
│ SERVER KNOWS                      │ SERVER NEVER KNOWS               │
├────────────────────────────────────┼──────────────────────────────────┤
│ User email                        │ Master password                  │
│ bcrypt(AuthHash)                  │ Master key                       │
│ Argon2id salt + KDF params        │ EncKey or MACKey                 │
│ Encrypted vault blobs             │ Any plaintext vault data         │
│ Entry count + sizes               │ Hostnames, IPs, ports            │
│ Entry types (host/key/snippet)    │ Usernames or passwords           │
│ Sync timestamps                   │ SSH private keys                 │
│ Device metadata (optional)        │ Snippets content                 │
│ IP addresses (from logs)          │ Known host fingerprints          │
└────────────────────────────────────┴──────────────────────────────────┘
```

---

## 4. Client-Side Security

### 4.1 Platform Secure Storage Map

```
┌────────────────┬───────────────────────────────────────────────────────────┐
│ Platform       │ Storage & Protection                                     │
├────────────────┼───────────────────────────────────────────────────────────┤
│ iOS            │ Keychain Services                                        │
│                │   • Hardware-backed via Secure Enclave (A7+ chips)       │
│                │   • Accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly │
│                │   • Prevents migration to other devices (stays on-device)│
│                │   • Items deleted if device is reset                     │
│                │   • Biometric gate: kSecAccessControlBiometryCurrentSet  │
│                │                                                          │
│ macOS          │ Keychain Services                                        │
│                │   • Login keychain (password-protected)                  │
│                │   • Access: kSecAttrAccessibleWhenUnlocked               │
│                │   • Touch ID gating where available                      │
│                │                                                          │
│ Android        │ Android Keystore + EncryptedSharedPreferences            │
│                │   • Hardware-backed (TEE or StrongBox on Pixel/Samsung)  │
│                │   • Keys generated inside TEE, never extractable        │
│                │   • AES-GCM encryption with Keystore-held key           │
│                │   • BiometricPrompt for gated access                    │
│                │   • setUserAuthenticationRequired(true)                  │
│                │                                                          │
│ Windows        │ DPAPI (Data Protection API)                              │
│                │   • Encryption tied to user's Windows login              │
│                │   • Keys protected by user's password + machine SID     │
│                │   • flutter_secure_storage wraps in encrypted file      │
│                │   • Windows Hello for biometric gate                     │
│                │                                                          │
│ Linux          │ libsecret (GNOME Keyring / KDE Wallet)                  │
│                │   • Encrypted keyring unlocked at login                  │
│                │   • Backed by kernel keyring or TPM where available      │
└────────────────┴───────────────────────────────────────────────────────────┘
```

### 4.2 Data at Rest Protection

```
LAYER 1: Platform Encryption
├── iOS: Complete Data Protection (NSFileProtectionComplete)
├── Android: File-based encryption (FBE)
├── macOS: FileVault (full-disk encryption)
└── Windows: BitLocker / EFS

LAYER 2: Database Encryption
├── SQLCipher (AES-256-CBC with HMAC-SHA512)
├── Database key stored in platform keychain
├── Key derived at app startup, never written to disk
└── Database is unreadable without the key

LAYER 3: Field-Level Encryption
├── SSH private keys: AES-256-GCM encrypted before keychain storage
├── Passwords: AES-256-GCM encrypted in database
├── Vault entries: per-item encrypted for sync
└── Encryption key from vault master key (Argon2id-derived)

LAYER 4: Memory Protection
├── Clear sensitive buffers after use (zero-fill)
├── Avoid storing passwords in String (use List<int>, wipe after)
├── No sensitive data in app logs
├── Disable screenshot in sensitive screens (Android FLAG_SECURE)
└── Obfuscate release builds (--obfuscate --split-debug-info)
```

### 4.3 Data in Transit Protection

```
SSH CONNECTIONS
├── SSH2 protocol (inherently encrypted, authenticated)
├── Host key verification (TOFU + known_hosts database)
├── Supported key exchange: curve25519-sha256, diffie-hellman-group16-sha512
├── Supported ciphers: chacha20-poly1305@openssh.com, aes256-gcm@openssh.com, aes256-ctr
├── Supported MACs: hmac-sha2-256-etm@openssh.com, hmac-sha2-512-etm@openssh.com
├── Reject weak algorithms: arcfour, 3des-cbc, hmac-md5, diffie-hellman-group1-sha1
└── User-configurable algorithm preferences (advanced settings)

SYNC API CONNECTIONS
├── TLS 1.3 only (reject TLS 1.2 and below)
├── Certificate pinning (backup pin for rotation)
├── HSTS headers on server
├── Payload is E2E encrypted (TLS is defense-in-depth, not primary)
├── JWT tokens in Authorization header (not URL params)
├── Tokens are short-lived (15 min access, 7 day refresh)
└── Refresh token rotation (one-time use)
```

### 4.4 Sensitive Data Handling Rules

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ RULE                                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│ 1. NEVER log sensitive data (passwords, keys, tokens, hostnames)           │
│    • Use [REDACTED] placeholders in logs                                   │
│    • Log only: connection status, error types, timing metrics              │
│                                                                             │
│ 2. NEVER store passwords in Dart Strings                                   │
│    • Strings are immutable and interned → cannot be zeroed                 │
│    • Use Uint8List for sensitive data, zero-fill after use                 │
│    • Example: password = Uint8List(0); // overwrite reference              │
│                                                                             │
│ 3. NEVER include sensitive data in error reports / crash logs              │
│    • Scrub stack traces before sending                                     │
│    • No connection details in error context                                │
│                                                                             │
│ 4. NEVER pass sensitive data through URL parameters                        │
│    • URLs appear in server logs, browser history, referrer headers         │
│    • Always use POST body or secure headers                                │
│                                                                             │
│ 5. NEVER store sensitive data in SharedPreferences / UserDefaults          │
│    • These are plaintext plist/XML files                                   │
│    • Use flutter_secure_storage (keychain) exclusively                     │
│                                                                             │
│ 6. NEVER display private keys in the UI                                    │
│    • Public key: always viewable                                           │
│    • Private key: never viewable (export-only, requires biometric re-auth)│
│    • Fingerprint: always viewable                                          │
│                                                                             │
│ 7. NEVER transmit vault data unencrypted                                   │
│    • All vault sync payloads are E2E encrypted client-side                 │
│    • Even a MITM with TLS termination sees only ciphertext                │
│                                                                             │
│ 8. ALWAYS clear clipboard after copying sensitive data                     │
│    • Default timeout: 30 seconds                                           │
│    • Also clear on app background                                          │
│    • On iOS 16+: use UIPasteboard.general with expiration                  │
│    • On Android 13+: use ClipData with isSensitive flag                    │
│                                                                             │
│ 9. ALWAYS verify host key fingerprints                                     │
│    • First connection: show fingerprint, require explicit accept           │
│    • Changed key: FULL SCREEN WARNING, red, require acknowledgment        │
│    • Never auto-accept changed keys                                        │
│                                                                             │
│ 10. ALWAYS use CSPRNG for all random values                                │
│     • Keys, IVs, nonces, salts, tokens                                    │
│     • dart:math Random() is NOT secure — use SecureRandom                 │
│     • Verify entropy source on each platform                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Backend Security

### 5.1 API Security

```
AUTHENTICATION
├── JWT access tokens (15 min expiry, RS256 signed)
├── Refresh tokens (7 day expiry, one-time use, stored hashed in DB)
├── Refresh token rotation (new pair on every refresh)
├── Revoke all sessions on password change
├── Optional TOTP 2FA (RFC 6238)
├── FIDO2/WebAuthn support (Phase 5)
└── Account lockout after 10 failed logins (progressive: 1m, 5m, 15m, 1h, 24h)

RATE LIMITING (per IP + per user)
├── Login:          5 attempts / minute
├── Registration:   3 attempts / hour
├── Password reset: 3 attempts / hour
├── Vault sync:     60 requests / minute
├── General API:    120 requests / minute
└── Implementation: Redis sliding window counter

INPUT VALIDATION
├── All inputs validated on server (never trust client)
├── Email: RFC 5322 validation + domain MX check
├── Passwords: min 10 chars, max 128 chars, check against breach DB (k-Anonymity via HaveIBeenPwned API)
├── Vault entries: max size 1MB per entry, max 10000 entries per user
├── Hostname/IP: strict pattern validation (no injection payloads)
└── Parameterized queries ONLY (no string concatenation for SQL)

HEADERS
├── Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
├── Content-Security-Policy: default-src 'none'
├── X-Content-Type-Options: nosniff
├── X-Frame-Options: DENY
├── X-XSS-Protection: 0 (CSP handles this)
├── Referrer-Policy: no-referrer
├── Permissions-Policy: camera=(), microphone=(), geolocation=()
└── Cache-Control: no-store (on all API responses)
```

### 5.2 Database Security

```
PostgreSQL Hardening
├── Separate database user for application (no superuser)
├── GRANT only SELECT, INSERT, UPDATE, DELETE on needed tables
├── No CREATE, DROP, ALTER in app user permissions
├── Connection via Unix socket (not TCP) where possible
├── SSL required for TCP connections
├── Connection pooling via PgBouncer (limit concurrent connections)
├── Encrypted backups (AES-256, separate backup encryption key)
├── Automated backup rotation (7 daily, 4 weekly, 12 monthly)
└── Audit log table for all data modifications

Schema Security
├── UUIDs for all primary keys (no sequential IDs)
├── Row-Level Security (RLS) policies
│   └── Users can only access their own vault entries
├── Encrypted columns for email (reversible, for login lookup)
├── bcrypt for auth_hash storage (cost 12)
├── TOTP secrets encrypted at rest (server-side AES)
├── Timestamps use UTC, no timezone information leaks
└── Soft delete with tombstone flag (no hard deletes in normal operation)
```

### 5.3 Infrastructure Security

```
Server Deployment
├── Container-based deployment (Docker)
├── Non-root container user
├── Read-only filesystem (except /tmp and explicit mounts)
├── No SSH access to production containers
├── Secrets via environment variables (never in image)
├── Health check endpoint (no sensitive info)
├── Graceful shutdown handling
└── Resource limits (CPU, memory, file descriptors)

Network
├── TLS termination at load balancer (Let's Encrypt with auto-renewal)
├── Internal services communicate via private network
├── Firewall: allow only 443 inbound, deny all else
├── DDoS protection (Cloudflare or equivalent)
├── Geographic access restrictions (optional, user-configurable)
└── No direct database access from internet

Monitoring & Alerting
├── Failed login attempt spikes → alert
├── Vault access anomalies (e.g., bulk download) → alert + rate limit
├── Server error rate > 1% → alert
├── Certificate expiry < 14 days → alert
├── Disk usage > 80% → alert
├── Unusual API patterns (new country, new device) → notify user
└── All security events → immutable audit log (append-only)
```

---

## 6. Application Security (OWASP Mobile Top 10)

```
┌────────────────────────────────────────────────────────────────────────────┐
│ OWASP Mobile Risk          │ Our Mitigation                               │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M1: Improper Credential    │ • Platform keychain for all credentials      │
│     Usage                  │ • Never hardcode keys or secrets             │
│                            │ • Vault encryption for stored credentials    │
│                            │ • No default/backdoor passwords              │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M2: Inadequate Supply      │ • Pin dependency versions in pubspec.lock    │
│     Chain Security         │ • Audit dependencies before update           │
│                            │ • Minimal dependency footprint               │
│                            │ • SCA scanning (dart pub outdated + audit)   │
│                            │ • Signed release builds                      │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M3: Insecure Auth /        │ • Argon2id KDF (memory-hard)                │
│     Authorization          │ • JWT with short expiry + refresh rotation   │
│                            │ • Biometric gating for sensitive ops         │
│                            │ • Server-side authorization on all endpoints │
│                            │ • RLS in PostgreSQL as second layer          │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M4: Insufficient I/O       │ • All inputs validated server-side           │
│     Validation             │ • Parameterized SQL queries only             │
│                            │ • Strict hostname/IP pattern validation      │
│                            │ • Command snippet sandboxing (no injection)  │
│                            │ • Max size limits on all inputs              │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M5: Insecure               │ • TLS 1.3 for all network communication     │
│     Communication          │ • Certificate pinning on sync API           │
│                            │ • SSH protocol for terminal (inherently E2E) │
│                            │ • No sensitive data in URL parameters        │
│                            │ • HSTS on all web endpoints                  │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M6: Inadequate Privacy     │ • No analytics without explicit consent     │
│     Controls               │ • No user tracking                          │
│                            │ • Data deletion on account removal           │
│                            │ • GDPR-compliant data export                │
│                            │ • Minimal data collection                    │
│                            │ • Privacy policy in-app                     │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M7: Insufficient Binary    │ • Release builds: --obfuscate               │
│     Protections            │ • --split-debug-info (separate symbols)     │
│                            │ • Root/jailbreak detection (warn, don't block)│
│                            │ • Debugger detection in release             │
│                            │ • Code signing on all platforms              │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M8: Security               │ • No debug info in release builds           │
│     Misconfiguration       │ • Android: allowBackup=false                │
│                            │ • iOS: NSFileProtectionComplete             │
│                            │ • No exported activities/services            │
│                            │ • Proper intent filter restrictions          │
│                            │ • Network security config (no cleartext)    │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M9: Insecure Data          │ • SQLCipher for local database              │
│     Storage                │ • Platform keychain for secrets             │
│                            │ • No sensitive data in SharedPreferences    │
│                            │ • No sensitive data in logs                 │
│                            │ • Temporary files encrypted + wiped         │
│                            │ • No sensitive data in app screenshots      │
├────────────────────────────┼──────────────────────────────────────────────┤
│ M10: Insufficient          │ • AES-256-GCM (authenticated encryption)    │
│      Cryptography          │ • No ECB mode, no CBC without HMAC         │
│                            │ • Unique IV/nonce per encryption operation  │
│                            │ • CSPRNG for all random values              │
│                            │ • No custom crypto implementations          │
│                            │ • Use well-audited libraries only           │
└────────────────────────────┴──────────────────────────────────────────────┘
```

---

## 7. Security Audit Schedule

```
┌──────────────┬───────────────────────────────────────────────────────────────┐
│ Frequency    │ Activity                                                     │
├──────────────┼───────────────────────────────────────────────────────────────┤
│ Every commit │ • Static analysis (dart analyze --fatal-infos)               │
│              │ • Dependency check (dart pub outdated)                       │
│              │ • Linter rules enforcement (analysis_options.yaml)           │
│              │ • Unit tests for crypto functions                            │
├──────────────┼───────────────────────────────────────────────────────────────┤
│ Every sprint │ • Manual security review of new code                        │
│ (2 weeks)    │ • Check for hardcoded secrets (gitleaks / trufflehog)       │
│              │ • Review new dependency additions                           │
│              │ • Test authentication and authorization flows               │
├──────────────┼───────────────────────────────────────────────────────────────┤
│ Every release│ • Full SCA scan (Software Composition Analysis)             │
│              │ • SAST scan (Static Application Security Testing)           │
│              │ • API security testing (OWASP ZAP / Burp Suite Community)   │
│              │ • Binary analysis of release builds                         │
│              │ • Verify obfuscation and debug info stripping               │
├──────────────┼───────────────────────────────────────────────────────────────┤
│ Quarterly    │ • Full threat model review and update                       │
│              │ • Crypto algorithm review (check for deprecations)          │
│              │ • Access control audit (backend permissions)                │
│              │ • Backup restoration test                                   │
│              │ • Incident response plan review                             │
├──────────────┼───────────────────────────────────────────────────────────────┤
│ Annually     │ • External penetration test (third-party security firm)     │
│              │ • Crypto implementation audit (third-party)                 │
│              │ • SOC 2 Type II assessment (if pursuing compliance)         │
│              │ • Full security documentation review                        │
└──────────────┴───────────────────────────────────────────────────────────────┘
```

---

## 8. Incident Response Plan

### 8.1 Severity Levels

```
┌────────┬───────────────────────────────┬──────────────────────┬────────────┐
│ Level  │ Description                   │ Response Time        │ Example    │
├────────┼───────────────────────────────┼──────────────────────┼────────────┤
│ SEV 1  │ Active data breach, key       │ Immediate (< 1 hour)│ Database   │
│ CRITICAL│ material exposure             │ All hands            │ dump leaked│
├────────┼───────────────────────────────┼──────────────────────┼────────────┤
│ SEV 2  │ Vulnerability that could lead │ < 4 hours            │ Auth bypass│
│ HIGH   │ to data access if exploited   │ Primary team         │ discovered │
├────────┼───────────────────────────────┼──────────────────────┼────────────┤
│ SEV 3  │ Security weakness, no active  │ < 24 hours           │ Weak cipher│
│ MEDIUM │ exploitation evidence         │ Assigned engineer    │ still used │
├────────┼───────────────────────────────┼──────────────────────┼────────────┤
│ SEV 4  │ Minor security improvement    │ Next sprint          │ Missing    │
│ LOW    │ or hardening                  │ Backlog              │ header     │
└────────┴───────────────────────────────┴──────────────────────┴────────────┘
```

### 8.2 Response Procedure

```
PHASE 1: DETECT & TRIAGE (0-1 hours)
├── Confirm the incident is real (not false positive)
├── Classify severity level
├── Activate response team
├── Begin incident log (who, what, when, where)
└── Preserve evidence (logs, snapshots, network captures)

PHASE 2: CONTAIN (1-4 hours)
├── SEV 1: Immediately rotate all signing keys
├── SEV 1: Revoke all JWT tokens (force re-authentication)
├── SEV 1: Take affected services offline if needed
├── Isolate compromised systems
├── Block attacker IPs/accounts
└── Enable enhanced logging

PHASE 3: ERADICATE (4-24 hours)
├── Identify root cause
├── Patch vulnerability
├── Remove attacker access/persistence
├── Review all related systems
└── Verify fix effectiveness

PHASE 4: RECOVER (24-72 hours)
├── Restore services from known-good state
├── Gradual re-enablement with monitoring
├── Verify data integrity
├── Reset affected user credentials (if needed)
└── Deploy patched version to all app stores

PHASE 5: NOTIFY (within 72 hours of confirmation)
├── Notify affected users via email + in-app banner
├── Explain: what happened, what data was affected, what we did
├── Provide: password reset link, steps users should take
├── Report to authorities if required (GDPR: 72 hours)
├── Publish post-mortem (within 30 days)
└── Update security documentation

PHASE 6: LESSONS LEARNED (within 14 days)
├── Blameless post-mortem meeting
├── Document timeline and decisions
├── Identify process improvements
├── Update threat model
├── Update incident response plan
└── Implement preventive measures
```

---

## 9. Privacy & Compliance

### 9.1 Data Minimization

```
WE COLLECT (minimum needed):
├── Email address (for account, sync, password reset)
├── Encrypted vault blobs (opaque to us)
├── KDF parameters and salt (needed for key derivation)
├── Account creation timestamp
├── Last login timestamp
└── Device count (for sync management)

WE DO NOT COLLECT:
├── Analytics or usage telemetry (unless user opts in)
├── IP address logging (beyond 48-hour security logs)
├── Device identifiers (IDFA, GAID)
├── Connection metadata (which servers users connect to)
├── Crash reports with user data
├── Location data
├── Contact lists
└── Any plaintext vault contents
```

### 9.2 Compliance Framework

```
GDPR (EU)
├── Right to access: user can export all data
├── Right to erasure: account deletion removes all data within 30 days
├── Right to portability: encrypted JSON vault export
├── Data processing agreement available
├── No data transfers outside specified regions (configurable)
├── Privacy impact assessment documented
├── Data breach notification within 72 hours
└── Consent-based data processing only

CCPA (California)
├── Privacy policy lists all data collected
├── "Do Not Sell" — we never sell data
├── User can request data deletion
└── Annual privacy review

APP STORE REQUIREMENTS
├── iOS: App Tracking Transparency not needed (no tracking)
├── iOS: Privacy Nutrition Label (accurate)
├── Google Play: Data Safety section (accurate)
├── Both: COPPA compliance (13+ age requirement)
└── Both: Encryption declaration (uses encryption for data protection)
```

### 9.3 User Controls

```
In-App Privacy Controls:
├── View all stored data (decrypted, local-only display)
├── Export vault (encrypted JSON file)
├── Delete individual entries permanently
├── Delete account and all server-side data
├── Opt-in/out of anonymous crash reporting
├── Clear all local data (factory reset)
├── View active sessions (other devices)
├── Revoke access for specific devices
└── Audit log: last 30 days of vault access events
```

---

## 10. Secure Development Lifecycle (SDL)

```
┌──────────────┬─────────────────────────────────────────────────────────────┐
│ Phase        │ Security Activities                                        │
├──────────────┼─────────────────────────────────────────────────────────────┤
│ DESIGN       │ • Threat modeling for each new feature                     │
│              │ • Security requirements in feature specs                   │
│              │ • Privacy-by-design review                                 │
│              │ • Crypto protocol review before implementation             │
├──────────────┼─────────────────────────────────────────────────────────────┤
│ DEVELOPMENT  │ • Secure coding guidelines (this document)                │
│              │ • Pre-commit hooks: no secrets in code (gitleaks)          │
│              │ • Linter rules: enforce security patterns                  │
│              │ • Peer review: security-focused code review checklist      │
│              │ • No TODO/HACK comments for security items (fix now)       │
├──────────────┼─────────────────────────────────────────────────────────────┤
│ TESTING      │ • Unit tests for all crypto operations                    │
│              │ • Integration tests for auth flows                        │
│              │ • Fuzzing for input parsing (hostnames, keys)             │
│              │ • Negative testing (invalid inputs, edge cases)           │
│              │ • TLS/SSL verification tests                              │
├──────────────┼─────────────────────────────────────────────────────────────┤
│ RELEASE      │ • Signed builds (code signing certificates)               │
│              │ • Reproducible builds (verifiable by community)           │
│              │ • Security changelog in release notes                     │
│              │ • Verify obfuscation in release APK/IPA                   │
│              │ • Final SCA + SAST scan                                   │
├──────────────┼─────────────────────────────────────────────────────────────┤
│ POST-RELEASE │ • Security bug bounty program (future)                    │
│              │ • CVE monitoring for dependencies                         │
│              │ • User-reported vulnerability triage (< 24h response)     │
│              │ • Emergency patch process (< 48h for critical)            │
└──────────────┴─────────────────────────────────────────────────────────────┘
```

---

## 11. Security Feature Checklist by Phase

```
Phase 1 (Core - must ship with):
  ✓ Platform keychain storage for private keys
  ✓ SQLCipher encrypted database
  ✓ SSH host key verification (TOFU)
  ✓ Known hosts database
  ✓ No sensitive data in logs
  ✓ No cleartext network (android:usesCleartextTraffic=false)
  ✓ Reject weak SSH algorithms
  ✓ Signed release builds

Phase 2 (Advanced):
  ✓ Clipboard auto-clear
  ✓ Auto-lock idle timer
  ✓ Screenshot protection (Android FLAG_SECURE)
  ✓ SSH algorithm configuration UI

Phase 3 (Sync):
  ✓ Argon2id KDF vault encryption
  ✓ AES-256-GCM per-item encryption
  ✓ Zero-knowledge sync protocol
  ✓ TLS 1.3 + certificate pinning
  ✓ JWT auth with refresh rotation
  ✓ Master password strength enforcement
  ✓ Biometric unlock
  ✓ TOTP 2FA
  ✓ Rate limiting
  ✓ Account lockout
  ✓ Brute-force protection (progressive delays)

Phase 4 (Polish):
  ✓ Root/jailbreak detection (warning)
  ✓ Remote session revocation
  ✓ Data export (encrypted)
  ✓ Account deletion flow
  ✓ Security audit (internal)
  ✓ Backup encryption

Phase 5 (Ecosystem):
  ✓ FIDO2/WebAuthn support
  ✓ Team vault access control
  ✓ Audit logging for team actions
  ✓ External penetration test
  ✓ Bug bounty program launch
```
