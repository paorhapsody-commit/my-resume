// =====================================================================
//  ตั้งค่า Supabase
//  ลำดับการอ่านค่า:
//   1) localStorage (ตั้งผ่านหน้า setup.html เฉพาะเบราว์เซอร์นี้)
//   2) ค่า runtime ที่ GitHub Actions เขียนให้ตอน deploy
//
//  ไฟล์ที่ commit ลง git ต้องไม่มี key จริง
//  ให้ตั้งค่า SUPABASE_URL และ SUPABASE_ANON_KEY ใน GitHub Environment
// =====================================================================
(function () {
  var DEFAULTS = {
    url: "",
    anonKey: ""
  };
  var saved = {};
  try { saved = JSON.parse(localStorage.getItem('resume_db_config') || '{}'); } catch (e) {}
  window.SUPABASE_URL      = (saved && saved.url)     || DEFAULTS.url;
  window.SUPABASE_ANON_KEY = (saved && saved.anonKey) || DEFAULTS.anonKey;
})();
