# Supabase Backend Setup

CloudShell uses [Supabase](https://supabase.com) as an optional backend for user authentication and end-to-end encrypted cross-device sync. **The app works fully offline without Supabase** — all SSH connections, terminal sessions, and local data are independent of any backend.

When configured, the backend enables:

- Account creation and login (email/password + optional TOTP 2FA)
- E2E encrypted sync of hosts, SSH keys (metadata only), groups, snippets, and port forward rules
- Cross-device vault unlock via Argon2id-derived keys

---

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in (or create an account)
2. Click **New Project**
3. Choose an organization, set a project name (e.g., `cloudshell`), and pick a region close to you
4. Set a strong database password (you won't need it in the app — only for direct DB access)
5. Wait for the project to provision (~2 minutes)

### Get Your Credentials

Once the project is ready:

1. Go to **Settings > API** in the Supabase Dashboard
2. Copy the **Project URL** (e.g., `https://abcdefgh.supabase.co`)
3. Copy the **anon public** key (starts with `eyJ...`)

These two values are all you need to configure the app.

> The free tier is sufficient for personal use. Supabase's free plan includes 500MB database, 50K monthly active users, and 5GB bandwidth.

---

## 2. Run the Database Schema

1. In the Supabase Dashboard, go to **SQL Editor**
2. Click **New Query**
3. Paste the contents of [`supabase/schema.sql`](../supabase/schema.sql) into the editor
4. Click **Run**

This creates two tables:

| Table | Purpose |
|-------|---------|
| `vault_config` | Per-user KDF salt and Argon2id parameters for multi-device vault unlock |
| `sync_items` | Encrypted sync payloads stored as opaque text blobs |

Both tables have **Row Level Security (RLS)** enabled — each user can only read and write their own data. The server never has access to plaintext credentials or SSH keys.

The schema also creates:
- A unique constraint on `(user_id, entity_type, entity_id)` for conflict-free sync
- An index on `(user_id, entity_type, sync_version)` for efficient pull queries
- Auto-update triggers for `updated_at` timestamps

---

## 3. Enable Authentication

1. In the Supabase Dashboard, go to **Authentication > Providers**
2. Ensure **Email** provider is enabled (it is by default)
3. Configure email settings:
   - **Confirm email**: Enable for production, disable for development
   - **Secure email change**: Recommended enabled

### Optional: Custom SMTP

By default, Supabase sends emails from their domain with rate limits. For production:

1. Go to **Settings > Authentication > SMTP Settings**
2. Configure your own SMTP provider (e.g., Resend, SendGrid, Postmark)

### Optional: TOTP Two-Factor Authentication

CloudShell supports TOTP 2FA (authenticator apps like Authy, Google Authenticator):

1. Go to **Authentication > Multi-Factor Authentication**
2. Enable **TOTP**

Users can then set up 2FA from the app's Settings > Security screen.

---

## 4. Configure the App

CloudShell reads Supabase credentials from compile-time environment variables. Pass them via `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

If these variables are not set, the app runs in **local-only mode** — no sign-up/login screens, no sync, fully functional otherwise.

### For CI/CD (GitHub Actions)

Add secrets to your repository:

1. Go to **Settings > Secrets and variables > Actions** in your GitHub repo
2. Add `SUPABASE_URL` and `SUPABASE_ANON_KEY` as repository secrets

Reference them in your workflow:

```yaml
- name: Build with Supabase
  run: flutter build apk --release --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
```

### For VS Code

Add to `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "CloudShell (with Supabase)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=SUPABASE_URL=https://your-project.supabase.co",
        "--dart-define=SUPABASE_ANON_KEY=eyJ..."
      ]
    }
  ]
}
```

> Do not commit `.vscode/launch.json` with real credentials. Add it to `.gitignore` or use a `.env` loader.

---

## 5. How Sync Works

CloudShell implements **zero-knowledge E2E encrypted sync**. The server only stores opaque encrypted blobs — it never sees your passwords, SSH keys, or host configurations in plaintext.

### Encryption Flow

1. User creates a master password → Argon2id KDF (64MB memory, 3 iterations, 4 parallelism) derives a master key
2. HKDF-SHA256 expands the master key into an encryption key and a MAC key
3. Each sync item is encrypted with a unique per-item AES-256-GCM key
4. Encrypted payloads are pushed to Supabase as opaque text

### Sync Entities

| Entity | What Syncs |
|--------|-----------|
| Hosts | Hostname, port, username, protocol, tags, settings (passwords stored separately in vault) |
| SSH Keys | Key name, type, fingerprint (private key material stays in OS keychain) |
| Groups | Name, color, parent group, sort order |
| Snippets | Name, command template, variables |
| Port Forwards | Source/destination, type (local/remote/dynamic) |

### Auto-Sync

When all conditions are met, sync runs automatically every 5 minutes:
- User is authenticated
- Vault is unlocked
- Sync is enabled in Settings

Changes are also pushed immediately when you modify data locally.

### Conflict Resolution

Sync uses a Lamport clock (`sync_version` column) for last-writer-wins conflict resolution. Each entity type syncs independently.

---

## 6. Self-Hosting

Supabase is open source and can be self-hosted:

1. Follow the [Supabase Self-Hosting Guide](https://supabase.com/docs/guides/self-hosting)
2. Run the same `supabase/schema.sql` on your self-hosted instance
3. Point `SUPABASE_URL` and `SUPABASE_ANON_KEY` to your instance

### Swapping Backends

The app uses abstract `AuthBackend` and `SyncBackend` interfaces (defined in `lib/services/backend/`). The Supabase implementation can be swapped for any other backend by:

1. Implementing `AuthBackend` and `SyncBackend` interfaces
2. Updating the providers in `lib/providers/backend_provider.dart`

---

## 7. Account Deletion

To support account deletion, create an RPC function in Supabase:

1. Go to **SQL Editor** and run:

```sql
create or replace function delete_user()
returns void as $$
begin
  delete from auth.users where id = auth.uid();
end;
$$ language plpgsql security definer;
```

This allows users to delete their account from the app's Settings screen.

---

## 8. Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| App shows no login/sync options | `--dart-define` vars not set | Pass `SUPABASE_URL` and `SUPABASE_ANON_KEY` at build time |
| "Invalid email or password" | Wrong credentials or email not confirmed | Check email confirmation settings in Supabase Dashboard |
| Sync not working | Vault locked or sync disabled | Unlock vault and enable sync in Settings > Security |
| RLS policy errors | Schema not applied correctly | Re-run `supabase/schema.sql` in SQL Editor |
| "Too many requests" | Supabase rate limiting | Wait and retry; consider upgrading plan for production |
| Account deletion fails | `delete_user` RPC not created | Run the SQL in Section 7 above |
