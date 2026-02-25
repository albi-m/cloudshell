-- CloudShell Supabase Schema
--
-- Run this in Supabase Dashboard → SQL Editor → New Query
-- One-time setup for the sync backend.
--
-- Tables:
--   vault_config  — Per-user KDF salt + params for multi-device vault unlock
--   sync_items    — Encrypted sync payloads (all entity types as opaque blobs)
--
-- Both tables use Row Level Security (RLS) so each user can only
-- access their own data.

-- ---------------------------------------------------------------------------
-- Vault configuration per user
-- ---------------------------------------------------------------------------

create table vault_config (
  user_id uuid references auth.users(id) on delete cascade primary key,
  kdf_salt text not null,
  kdf_params jsonb not null default '{"memory": 65536, "iterations": 3, "parallelism": 4}',
  verification_token text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table vault_config enable row level security;
create policy "Users manage own vault config"
  on vault_config for all using (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- Encrypted sync items
-- ---------------------------------------------------------------------------

create table sync_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  entity_type text not null check (entity_type in ('host', 'ssh_key', 'group', 'snippet', 'port_forward')),
  entity_id text not null,
  encrypted_data text not null,
  sync_version bigint not null default 0,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, entity_type, entity_id)
);

alter table sync_items enable row level security;
create policy "Users manage own sync items"
  on sync_items for all using (auth.uid() = user_id);

create index idx_sync_items_user_type_version
  on sync_items(user_id, entity_type, sync_version);

-- ---------------------------------------------------------------------------
-- Auto-update timestamp trigger
-- ---------------------------------------------------------------------------

create or replace function update_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

create trigger vault_config_updated before update on vault_config
  for each row execute function update_updated_at();
create trigger sync_items_updated before update on sync_items
  for each row execute function update_updated_at();
