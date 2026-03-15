-- ============================================================
-- Hareru - Supabase sync schema
-- Generated: 2026-03-14
-- ============================================================

-- 1. user_transactions
create table if not exists public.user_transactions (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references auth.users(id) on delete cascade,
  local_id    text        not null,
  type        text        not null check (type in ('expense', 'transfer', 'savings', 'income')),
  amount      double precision not null,
  category    text        not null,
  memo        text,
  date        timestamptz not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  deleted_at  timestamptz,

  unique (user_id, local_id)
);

comment on table  public.user_transactions is 'Per-user transaction records synced from local Hive storage';
comment on column public.user_transactions.local_id is 'Hive key (Transaction.id) used to match local ↔ remote';
comment on column public.user_transactions.deleted_at is 'Soft-delete timestamp for sync conflict resolution';

-- 2. user_categories
create table if not exists public.user_categories (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references auth.users(id) on delete cascade,
  local_id    text        not null,
  name        text        not null,
  emoji       text        not null,
  type        text        not null check (type in ('expense', 'transfer', 'savings', 'income')),
  sort_order  int         not null default 0,
  is_default  boolean     not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  deleted_at  timestamptz,

  unique (user_id, local_id)
);

comment on table  public.user_categories is 'Per-user custom categories synced from local Hive storage';
comment on column public.user_categories.local_id is 'Hive key (Category.id) used to match local ↔ remote';

-- 3. user_settings
create table if not exists public.user_settings (
  user_id     uuid        primary key references auth.users(id) on delete cascade,
  budget      bigint      not null default 0,
  pay_day     int         not null default 0 check (pay_day >= 0 and pay_day <= 31),
  dark_mode   boolean     not null default false,
  locale      text        not null default 'ja' check (locale in ('ja', 'ko', 'en')),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

comment on table public.user_settings is 'Per-user app settings (budget, pay day, preferences)';

-- ============================================================
-- Indexes
-- ============================================================

create index idx_transactions_user_date on public.user_transactions (user_id, date desc);
create index idx_transactions_user_type  on public.user_transactions (user_id, type);
create index idx_categories_user        on public.user_categories   (user_id);

-- ============================================================
-- updated_at auto-trigger
-- ============================================================

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_transactions_updated_at
  before update on public.user_transactions
  for each row execute function public.set_updated_at();

create trigger trg_categories_updated_at
  before update on public.user_categories
  for each row execute function public.set_updated_at();

create trigger trg_settings_updated_at
  before update on public.user_settings
  for each row execute function public.set_updated_at();

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

-- user_transactions
alter table public.user_transactions enable row level security;

create policy "Users can select own transactions"
  on public.user_transactions for select
  using (auth.uid() = user_id);

create policy "Users can insert own transactions"
  on public.user_transactions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own transactions"
  on public.user_transactions for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete own transactions"
  on public.user_transactions for delete
  using (auth.uid() = user_id);

-- user_categories
alter table public.user_categories enable row level security;

create policy "Users can select own categories"
  on public.user_categories for select
  using (auth.uid() = user_id);

create policy "Users can insert own categories"
  on public.user_categories for insert
  with check (auth.uid() = user_id);

create policy "Users can update own categories"
  on public.user_categories for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete own categories"
  on public.user_categories for delete
  using (auth.uid() = user_id);

-- user_settings
alter table public.user_settings enable row level security;

create policy "Users can select own settings"
  on public.user_settings for select
  using (auth.uid() = user_id);

create policy "Users can insert own settings"
  on public.user_settings for insert
  with check (auth.uid() = user_id);

create policy "Users can update own settings"
  on public.user_settings for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
