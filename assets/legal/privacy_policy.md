# Privacy Policy

**Last updated: February 2026**

## Overview

CloudShell is an SSH client designed with privacy as a core principle. Your data belongs to you — we collect only what's strictly necessary to provide the service.

## Local-Only Mode

When used without an account, CloudShell operates entirely on your device:

- All hosts, SSH keys, passwords, and settings are stored locally
- No data is transmitted to any server
- No analytics or telemetry are collected
- No third-party services are contacted (except for optional font downloads)

## Cloud Sync Mode

When you create an account and enable sync:

- Your email address is stored for authentication
- Encrypted vault data is synced through our servers
- All synced data is encrypted end-to-end using AES-256-GCM with keys derived from your password via Argon2id
- We cannot read your synced data — zero-knowledge encryption means only you hold the decryption keys
- Sync data is stored on Supabase infrastructure

## What We Never Collect

- SSH session content or commands
- Private SSH keys (unless you opt into encrypted vault backup)
- Host passwords or connection credentials
- Terminal session recordings
- Usage analytics or behavioral data
- Device identifiers or fingerprints

## Encryption

- Local storage: AES-256-GCM with device-derived key
- Vault encryption: Argon2id key derivation + AES-256-GCM + HMAC-SHA256
- Per-item encryption with random keys
- Zero-knowledge architecture — servers never see plaintext

## Your Rights

You have the right to:

- **Export** all your data at any time (Settings > Data > Export)
- **Delete** your account and all server-side data (Settings > Account > Delete Account)
- **Use locally** without creating an account
- **Self-host** the sync server for full control

## Third-Party Services

- **Supabase** — Authentication and encrypted data sync (when using cloud sync)
- **Google Fonts** — Optional font downloads for UI (can be disabled)

## Data Retention

- Local data persists until you delete it or uninstall the app
- Cloud sync data is deleted when you delete your account
- No backups are retained after account deletion

## Contact

For privacy questions or data requests, reach us through the project's GitHub repository.
