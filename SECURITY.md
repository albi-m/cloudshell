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

## Security Measures

CloudShell implements several security measures:

- **Encryption at rest**: SSH keys and passwords are encrypted using AES-256-GCM with keys derived via Argon2id.
- **Host key verification**: TOFU (Trust On First Use) model with persistent known hosts database.
- **Clipboard auto-clear**: Sensitive data copied to clipboard is automatically cleared after a timeout.
- **Biometric lock**: Optional app-level biometric authentication (Touch ID / Face ID).
- **No telemetry**: CloudShell does not collect or transmit any usage data.

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
