# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x.x   | Yes       |

## Reporting a Vulnerability

If you discover a security vulnerability in CloudShell, please report it responsibly:

1. **Do not** open a public GitHub issue for security vulnerabilities.
2. Email security reports to the maintainers (see repository contact info).
3. Include a detailed description of the vulnerability and steps to reproduce.
4. Allow reasonable time for a fix before public disclosure.

## Security Architecture

### Encryption at Rest

CloudShell uses a two-tier encryption system:

**Local secrets** (SSH keys, host passwords):
- AES-256-GCM encryption via `AppCryptoService`
- Key derived from machine hardware UUID using PBKDF2-SHA256 (100,000 iterations)
- Secrets are device-bound and stored in an encrypted Drift/SQLite database

**Vault secrets** (when master password is configured):
- Argon2id key derivation (64 MB memory, 3 iterations, 4 parallelism)
- HKDF-SHA256 key expansion into separate encryption and MAC keys
- Per-item AES-256-GCM encryption with random item keys
- HMAC-SHA256 authentication over all ciphertext
- Constant-time HMAC comparison to prevent timing attacks
- Key material wiped from memory on vault lock

### Host Key Verification

TOFU (Trust On First Use) model with persistent known hosts database. On first connection, the server's host key fingerprint is displayed for manual verification. Subsequent connections verify against the stored key and alert on mismatches.

### Platform Security

| Platform | Measure |
|----------|---------|
| iOS | App Transport Security enabled (no exceptions) |
| Android | `allowBackup=false`, INTERNET permission only |
| macOS | App Sandbox enabled in release builds |
| All | No cleartext HTTP connections (SSH/SFTP only) |

### Clipboard Protection

All sensitive data copied to clipboard (passwords, keys, TOTP secrets) uses automatic clipboard clearing after a configurable timeout.

### Input Validation

- Hostnames validated against RFC 1123 + IPv4/IPv6
- Ports validated to 1-65535 range
- Usernames reject shell metacharacters
- SFTP paths normalized to prevent directory traversal

## Known Trade-offs

### PBKDF2 Auth Hash (1 iteration)
The server authentication hash uses PBKDF2-SHA256 with 1 iteration. This is intentional — the input key has already been through Argon2id (64 MB / 3 iterations). The PBKDF2 pass produces a one-way transformation for server auth, not key-stretching. This follows the [Bitwarden security model](https://bitwarden.com/help/bitwarden-security-white-paper/).

### Snippet Variable Substitution
Snippet variables are substituted without shell escaping. Snippets are user-authored commands sent to the user's own SSH terminal — the user already has full shell access. Shell escaping would break legitimate use cases (piping, redirection, etc.).

### Debug Build Parameters
Debug builds use reduced Argon2id parameters (1 MB / 1 iteration) for development speed. Release builds always use full parameters (64 MB / 3 iterations / 4 parallelism).

## Dependency Notes

- **dartssh2**: Advisory — CVE-2023-48795 (Terrapin Attack) may apply to SSH implementations. Requires man-in-the-middle position. Modern SSH servers (OpenSSH 9.5+) include countermeasures.
- **pointycastle 3.9.1**: Includes timing attack mitigations (constant-time AES, fixed GCM timing leaks).

## Security Measures Summary

- **Encryption at rest**: AES-256-GCM with Argon2id-derived keys
- **Host key verification**: TOFU model with persistent known hosts database
- **Clipboard auto-clear**: Sensitive data automatically cleared after timeout
- **Biometric lock**: Optional app-level biometric authentication (Touch ID / Face ID)
- **No telemetry**: CloudShell does not collect or transmit any usage data
- **No cleartext protocols**: SSH/SFTP only (Telnet available with explicit warning)
- **Backup prevention**: Android backups disabled to protect encrypted database

## Scope

The following are in scope for security reports:

- Authentication bypass
- Data leakage of SSH keys or passwords
- Remote code execution
- Injection vulnerabilities
- Cryptographic weaknesses

The following are out of scope:

- Denial of service against the local app
- Social engineering
- Issues requiring physical access to an unlocked device
