-- =====================================================================
--  Portfolio / Resume — โครงสร้างฐานข้อมูลทั้งระบบ (Supabase / PostgreSQL)
--  ไฟล์เดียวจบ: ตาราง + สิทธิ์ (RLS) + ที่เก็บไฟล์ (Storage)
--  รันใน Supabase → SQL Editor → New query → วางทั้งหมด → Run
--  ปลอดภัยกับฐานข้อมูลเดิม (ใช้ IF NOT EXISTS — ไม่แตะข้อมูลที่มีอยู่)
-- =====================================================================

-- =====================================================================
-- 1) PROJECTS — ผลงาน/ระบบที่พัฒนา
-- =====================================================================
create table if not exists public.projects (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  description text,                 -- คำอธิบายเต็ม (ใช้ในหน้าผลงาน)
  short_desc  text,                 -- คำอธิบายสั้น (ใช้ในส่วน Projects หน้า Resume)
  url         text,                 -- ลิงก์ผลงาน (ถ้ามี)
  icon        text default 'folder-kanban',  -- ชื่อไอคอน lucide
  category    text default 'ระบบงาน',
  image_url   text,                 -- รูปปก (= ภาพแรกใน images)
  images      text[] default '{}',  -- ภาพประกอบหลายรูป (Storage หรือ URL ภายนอก)
  tech        text[] default '{}',  -- เครื่องมือ/เทคโนโลยีที่ใช้
  featured    boolean default false,-- ติดดาวแสดงในส่วน Projects หน้า Resume (รวมสูงสุด 8)
  sort_order  int default 100,
  created_at  timestamptz default now()
);
create index if not exists projects_sort_idx on public.projects (sort_order, created_at desc);

alter table public.projects enable row level security;
drop policy if exists "public read" on public.projects;
create policy "public read"  on public.projects for select using (true);
drop policy if exists "auth insert" on public.projects;
create policy "auth insert" on public.projects for insert to authenticated with check (true);
drop policy if exists "auth update" on public.projects;
create policy "auth update" on public.projects for update to authenticated using (true) with check (true);
drop policy if exists "auth delete" on public.projects;
create policy "auth delete" on public.projects for delete to authenticated using (true);

-- =====================================================================
-- 2) SHOWCASE — ใบประกาศ / รางวัล / แกลเลอรี่ / อบรม-วิทยากร
-- =====================================================================
create table if not exists public.showcase (
  id          uuid primary key default gen_random_uuid(),
  type        text not null default 'certificate'
              check (type in ('certificate','award','gallery','training')),
  title       text,
  issuer      text,                 -- หน่วยงานที่ออก / ผู้จัด / ชื่องาน
  description text,
  date_text   text,                 -- วันที่/ปี (ข้อความอิสระ)
  tag         text,                 -- ป้ายเล็ก เช่น "วิทยากร" / "รองชนะเลิศ"
  url         text,
  image_url   text,
  featured    boolean default false,-- ติดดาวแสดงในส่วน Projects หน้า Resume (รวมสูงสุด 8)
  sort_order  int default 100,
  created_at  timestamptz default now()
);
create index if not exists showcase_type_idx on public.showcase (type, sort_order, created_at desc);

alter table public.showcase enable row level security;
drop policy if exists "sc public read" on public.showcase;
create policy "sc public read"  on public.showcase for select using (true);
drop policy if exists "sc auth insert" on public.showcase;
create policy "sc auth insert" on public.showcase for insert to authenticated with check (true);
drop policy if exists "sc auth update" on public.showcase;
create policy "sc auth update" on public.showcase for update to authenticated using (true) with check (true);
drop policy if exists "sc auth delete" on public.showcase;
create policy "sc auth delete" on public.showcase for delete to authenticated using (true);

-- =====================================================================
-- 3) SITE_SETTINGS — การตั้งค่าเว็บ (ธีม/สี/cover, ข้อมูลส่วนตัว, เนื้อหา)
--    เก็บแบบ key/value (jsonb): key = 'theme' | 'profile' | 'content'
-- =====================================================================
create table if not exists public.site_settings (
  key        text primary key,
  value      jsonb not null default '{}',
  updated_at timestamptz default now()
);

alter table public.site_settings enable row level security;
drop policy if exists "settings public read" on public.site_settings;
create policy "settings public read" on public.site_settings for select using (true);
drop policy if exists "settings auth write" on public.site_settings;
create policy "settings auth write" on public.site_settings
  for all to authenticated using (true) with check (true);

-- =====================================================================
-- 4) STORAGE — ที่เก็บรูปภาพ (public buckets)
-- =====================================================================
insert into storage.buckets (id, name, public) values ('project-images',  'project-images',  true) on conflict (id) do nothing;
insert into storage.buckets (id, name, public) values ('showcase-images', 'showcase-images', true) on conflict (id) do nothing;

drop policy if exists "img public read"  on storage.objects;
create policy "img public read"  on storage.objects for select
  using (bucket_id in ('project-images','showcase-images'));
drop policy if exists "img auth write"  on storage.objects;
create policy "img auth write"  on storage.objects for insert to authenticated
  with check (bucket_id in ('project-images','showcase-images'));
drop policy if exists "img auth delete" on storage.objects;
create policy "img auth delete" on storage.objects for delete to authenticated
  using (bucket_id in ('project-images','showcase-images'));
