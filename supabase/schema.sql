-- =====================================================================
-- 신한 Premier 패스파인더 · Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 RUN 하세요. (1회)
-- =====================================================================

-- 1) 위원(experts) 테이블 ------------------------------------------------
create table if not exists public.experts (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  title       text default '',
  field       text default '',
  affil       text default '',
  status      text default '',
  company     text default '',
  careers     jsonb default '[]'::jsonb,   -- 주요 경력 (문자열 배열)
  edu         text default '',
  book        text default '',
  photo_path  text,                        -- Storage 'expert-photos' 내 파일 경로
  sort_order  int  default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);
create index if not exists experts_name_idx  on public.experts (name);
create index if not exists experts_field_idx on public.experts (field);

-- updated_at 자동 갱신
create or replace function public.set_updated_at() returns trigger
language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists trg_experts_updated on public.experts;
create trigger trg_experts_updated before update on public.experts
  for each row execute function public.set_updated_at();

-- 2) RLS (행 수준 보안) --------------------------------------------------
-- ※ 사내 도구라 우선 익명(anon) 읽기/쓰기를 허용합니다.
--   외부 공개 배포 시에는 반드시 'authenticated' 로 좁히거나 통과코드를 두세요.
alter table public.experts enable row level security;
drop policy if exists experts_read   on public.experts;
drop policy if exists experts_insert on public.experts;
drop policy if exists experts_update on public.experts;
drop policy if exists experts_delete on public.experts;
create policy experts_read   on public.experts for select using (true);
create policy experts_insert on public.experts for insert with check (true);
create policy experts_update on public.experts for update using (true) with check (true);
create policy experts_delete on public.experts for delete using (true);

-- 3) 사진 저장용 Storage 버킷 -------------------------------------------
insert into storage.buckets (id, name, public)
values ('expert-photos','expert-photos', true)
on conflict (id) do nothing;
drop policy if exists photos_read  on storage.objects;
drop policy if exists photos_write on storage.objects;
drop policy if exists photos_upd   on storage.objects;
create policy photos_read  on storage.objects for select using (bucket_id='expert-photos');
create policy photos_write on storage.objects for insert with check (bucket_id='expert-photos');
create policy photos_upd   on storage.objects for update using (bucket_id='expert-photos');
