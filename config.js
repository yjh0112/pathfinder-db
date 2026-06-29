// 신한 Premier 패스파인더 DB · 공용 연결 설정
// 본부에서 아래 두 값을 채워 커밋하면, 모든 센터가 페이지만 열면 자동 연결됩니다.
// (anon key는 공개되어도 안전하도록 설계된 키이며, 접근은 Supabase RLS로 통제합니다.)
window.PF_CONFIG = {
  url: "https://rehwxynfxzotchwcofwa.supabase.co",   // 예: https://abcdxyz.supabase.co
  key: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlaHd4eW5meHpvdGNod2NvZndhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI2Njk0MTcsImV4cCI6MjA5ODI0NTQxN30.urLUMOQa5bQp9vX0RFxDqI67dSOydsE1ThgtAxn8TX0"    // anon public key (eyJ...)
};
