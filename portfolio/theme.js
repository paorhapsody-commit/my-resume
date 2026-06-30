// =====================================================================
//  theme.js — สร้างเฉดสี + ใช้ธีมกับหน้าเว็บ (ใช้ร่วมกัน resume + admin)
//  ธีมเก็บแค่ 2 สี: primary (สีหลัก ~ระดับ 700) + accent (สีเน้น ~ระดับ 500)
//  แล้วคำนวณเฉด navy 50–950 และ gold 400–600 อัตโนมัติ
// =====================================================================
(function (global) {
  function hexToRgb(hex) {
    hex = String(hex).replace('#', '').trim();
    if (hex.length === 3) hex = hex.split('').map(c => c + c).join('');
    const n = parseInt(hex, 16);
    return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
  }
  const clamp = v => Math.max(0, Math.min(255, Math.round(v)));
  // ผสมสีไปหา white (t>0) หรือ black (ใช้ mixBlack)
  const mixWhite = (rgb, t) => rgb.map(c => clamp(c + (255 - c) * t));
  const mixBlack = (rgb, t) => rgb.map(c => clamp(c * (1 - t)));
  const triplet = rgb => rgb.join(' ');

  // เฉด primary: ยึดสีที่เลือกเป็นระดับ 700
  function navyScale(primaryHex) {
    const b = hexToRgb(primaryHex);
    return {
      50:  triplet(mixWhite(b, 0.91)), 100: triplet(mixWhite(b, 0.84)),
      200: triplet(mixWhite(b, 0.72)), 300: triplet(mixWhite(b, 0.58)),
      400: triplet(mixWhite(b, 0.44)), 500: triplet(mixWhite(b, 0.30)),
      600: triplet(mixWhite(b, 0.16)), 700: triplet(b),
      800: triplet(mixBlack(b, 0.18)), 900: triplet(mixBlack(b, 0.34)),
      950: triplet(mixBlack(b, 0.46)),
    };
  }
  // เฉด accent: ยึดสีที่เลือกเป็นระดับ 500
  function goldScale(accentHex) {
    const b = hexToRgb(accentHex);
    return { 400: triplet(mixWhite(b, 0.20)), 500: triplet(b), 600: triplet(mixBlack(b, 0.20)) };
  }

  // ใช้ธีมกับ :root (set CSS variables เป็น "r g b")
  function applyTheme(theme) {
    if (!theme || !theme.primary || !theme.accent) return;
    const root = document.documentElement;
    const navy = navyScale(theme.primary), gold = goldScale(theme.accent);
    for (const k in navy) root.style.setProperty('--navy-' + k, navy[k]);
    for (const k in gold) root.style.setProperty('--gold-' + k, gold[k]);
  }

  const DEFAULT_THEME = { name: 'กรมท่า–ทอง', primary: '#1d2f73', accent: '#eaa916' };

  const PRESETS = [
    { name: 'กรมท่า–ทอง',  primary: '#1d2f73', accent: '#eaa916' },
    { name: 'มรกต–อำพัน',  primary: '#047857', accent: '#f59e0b' },
    { name: 'เลือดหมู–ทอง', primary: '#8a1f3f', accent: '#d4a017' },
    { name: 'ม่วง–ทอง',    primary: '#5b21b6', accent: '#eab308' },
    { name: 'เทา–ฟ้า',     primary: '#334155', accent: '#0ea5e9' },
    { name: 'ถ่าน–ส้ม',    primary: '#1f2937', accent: '#f97316' },
    { name: 'ป่าเขียว–ไลม์', primary: '#14532d', accent: '#84cc16' },
    { name: 'น้ำเงิน–ชมพู', primary: '#1e40af', accent: '#ec4899' },
  ];

  global.DCLTheme = { hexToRgb, navyScale, goldScale, applyTheme, DEFAULT_THEME, PRESETS };
})(window);
