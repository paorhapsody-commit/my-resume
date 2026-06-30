# หน้าผลงาน + ระบบจัดการผลงาน (Supabase)

โครงสร้างไฟล์ในโฟลเดอร์นี้
| ไฟล์ | หน้าที่ |
|------|---------|
| `works.html` | หน้าผลงาน (public) — คนทั่วไปดูได้ |
| `admin.html` | หน้า Admin — login แล้วเพิ่ม/แก้/ลบผลงาน + อัปโหลดรูป |
| `config.js`  | runtime config ของ Supabase (สร้างจาก GitHub Environment ตอน deploy) |
| `schema.sql` | สคริปต์สร้างตาราง/สิทธิ์/bucket ใน Supabase |

---

## ขั้นตอน setup (ครั้งเดียว ~10 นาที)

### 1) สร้างโปรเจกต์ Supabase
1. ไปที่ https://supabase.com → Sign in (ใช้ GitHub ได้) → **New project**
2. ตั้งชื่อ + รหัสผ่าน database (จดไว้) → เลือก region **Southeast Asia (Singapore)** → Create
3. รอ ~2 นาทีให้สร้างเสร็จ

### 2) สร้างตารางฐานข้อมูล
1. เมนูซ้าย → **SQL Editor** → **New query**
2. เปิดไฟล์ `schema.sql` คัดลอกทั้งหมดมาวาง → กด **Run**
   - สร้างทั้งระบบในครั้งเดียว: ตาราง `projects`, `showcase`, `site_settings` + เปิด RLS + สร้าง bucket `project-images`, `showcase-images`
   - เป็นโครงสร้างล้วน (ไม่มีข้อมูลตัวอย่าง) — เพิ่มผลงาน/ตั้งค่าได้ที่หน้า `admin.html`

### 3) สร้างบัญชี admin (คนที่จะ login)
1. เมนูซ้าย → **Authentication** → **Users** → **Add user** → **Create new user**
2. ใส่ email + password → ติ๊ก **Auto Confirm User** → Create
   - (ปิดการสมัครเองได้ที่ Authentication → Sign In / Providers → ปิด "Allow new users to sign up" เพื่อกันคนอื่นสมัคร)

### 4) ใส่ค่า key ลง GitHub Environment
1. เมนูซ้าย → **Project Settings** → **API Keys** (และ **Data API** สำหรับ URL)
2. คัดลอก **Project URL** และ **anon public key**
3. ไปที่ GitHub repo → **Settings** → **Environments** → `github-pages`
4. เพิ่ม Environment variables หรือ secrets ชื่อ:
   ```text
   SUPABASE_URL=https://xxxx.supabase.co
   SUPABASE_ANON_KEY=eyJhbGci...
   ```
5. ไม่ต้องใส่ค่า key จริงใน `portfolio/config.js` เพราะ `.github/workflows/deploy-pages.yml` จะสร้างไฟล์นี้จาก Environment ตอน deploy
6. ถ้าใช้ GitHub Pages ให้ไปที่ **Settings** → **Pages** แล้วตั้ง **Source** เป็น **GitHub Actions**

### 5) push ขึ้น GitHub
```bash
cd D:/MY/resume
git add .
git commit -m "เพิ่มหน้าผลงาน + ระบบจัดการผลงาน (Supabase)"
git push
```

---

## วิธีใช้งาน
- **หน้าผลงาน:**  `https://<user>.github.io/my-resume/portfolio/works.html`
- **หน้า Admin:** `https://<user>.github.io/my-resume/portfolio/admin.html` → login ด้วยบัญชีข้อ 3
- ในหน้า resume เดิมมีปุ่ม **"ดูผลงานทั้งหมด"** ลิงก์ไปหน้าผลงานแล้ว

## หมายเหตุ
- รูปที่อัปโหลดเก็บใน Supabase Storage (bucket `project-images`, public)
- ลบผลงานที่มีรูป → ระบบลบไฟล์รูปใน Storage ให้อัตโนมัติ
- ฟรีจริง: Supabase free tier = DB 500MB + Storage 1GB + Auth ไม่จำกัดผู้ใช้

