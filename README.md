# 신한 Premier 패스파인더 · 위원 DB

ETF 대시보드와 **완전히 분리된 단독 프로젝트**입니다. 위원(전문가) 데이터를 Supabase에 누적·공유하고, 안내장용 블록 통합본 PPT를 생성하는 본부용 도구입니다. 정적 페이지라 GitHub Pages에 그대로 배포됩니다.

## 구성
| 파일 | 설명 |
|---|---|
| `index.html` | 본부용 도구 (전문가 DB · 블록 생성 · 사진 매칭 QA · 통합본 PPT 내보내기) |
| `config.js` | 공용 Supabase 연결 설정 (본부가 1회 입력 후 커밋) |
| `supabase/schema.sql` | DB 스키마 (테이블·RLS·사진 버킷) — 최초 1회 실행 |
| `supabase/seed.sql` | 위원 109명 초기 데이터 |
| `.github/workflows/deploy.yml` | GitHub Pages 자동 배포 |

## 최초 설정 (약 10분)
1. **Supabase 프로젝트 생성** → supabase.com 에서 New project.
2. **SQL 실행** → 좌측 *SQL Editor* 에서 `supabase/schema.sql` 붙여넣고 RUN → 이어서 `supabase/seed.sql` RUN.
3. **연결값 입력** → *Project Settings ▸ API* 의 **Project URL** 과 **anon public key** 를 복사해 `config.js` 에 채우고 커밋.
   - 또는 앱 우측 상단 **[Supabase]** 버튼에서 직접 입력해도 됩니다(이 브라우저에만 저장).
4. 끝. 페이지를 열면 우측 상단 칩이 **● 온라인 (Supabase)** 으로 바뀌고, 모든 편집이 자동 저장·공유됩니다.

## 배포 (GitHub Pages)
- 이 폴더를 새 GitHub 저장소에 push.
- 저장소 **Settings ▸ Pages ▸ Source = GitHub Actions** 로 설정.
- `main` 에 push하면 자동 배포됩니다. (`.github/workflows/deploy.yml`)

## 데이터 동작
- **온라인**(config.js 또는 [Supabase] 연결 시): 위원 추가·수정이 Supabase에 즉시 저장되어 누적·공유됩니다.
- **오프라인**(미연결): 이 브라우저에만 임시 저장(localStorage)되며, 내장된 109명 데이터로 동작합니다.
- 빈 테이블에 처음 연결하면 내장 데이터가 자동으로 한 번 올라갑니다(시드 미실행 시 대비).
- 사진: 현재는 세션마다 zip/폴더로 불러옵니다. (Supabase Storage 영구 저장은 다음 단계 예정 — 버킷 `expert-photos` 는 미리 만들어 둠.)

## 🔑 인수인계 (Handoff) — 발령 시 통째로 넘기기
이 프로젝트는 **저장소 + DB** 두 가지만 넘기면 됩니다.

1. **저장소** → GitHub 저장소를 후임자에게 이전(Settings ▸ Transfer)하거나, 후임자가 Fork/clone.
2. **DB(둘 중 택1)**
   - (A) **Supabase 프로젝트 이전**: Supabase 조직 멤버로 후임자를 추가하거나 프로젝트 소유권 이전. → 데이터·사진 그대로 유지.
   - (B) **데이터만 이관**: 후임자가 자신의 Supabase 프로젝트를 만들고 `schema.sql` 실행 후, **앱의 [DB 내보내기]** 로 받은 최신 `experts_YYYY-MM-DD.json` 을 시드로 넣음. (간단 변환 스크립트는 본부에 요청)
3. **연결값** → 후임자가 자신의 Supabase URL/anon key 로 `config.js` 갱신.

> 권장: 인수인계 직전 앱에서 **[DB 내보내기]** 를 눌러 최신 스냅샷(JSON)을 저장소 `supabase/` 에 함께 커밋해 두면, 저장소만으로도 데이터가 보존됩니다.

## 보안 주의
- `config.js` 의 anon key 는 공개되어도 되는 키지만, **반드시 RLS(행 보안)로 접근을 통제**하세요. 외부 공개 배포 시 `schema.sql` 의 정책을 `authenticated` 로 좁히거나 사내망/통과코드를 권장합니다.
