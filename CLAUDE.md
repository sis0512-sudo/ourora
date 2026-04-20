# OURORA STUDIO — Flutter Web

가구공방 오로라스튜디오 홈페이지. Flutter Web 단일 스크롤 랜딩 페이지.

---

## 기술 스택

- Flutter 3.x / Dart 3.x (Web 타겟)
- 상태관리: `flutter_riverpod` + `riverpod_generator` (code gen)
- 라우팅: `go_router` (전환 애니메이션 없음 — `_noTransitionPage`)
- 데이터 모델: `freezed` + `fpdart` (`Either` 기반 에러처리)
- HTTP: `http` 패키지 직접 사용 (Instagram Graph API, YouTube)
- 기타: `carousel_slider`, `cached_network_image`, `flutter_svg`, `video_player`, `url_launcher`

---

## 디렉토리 구조

```
lib/
├── main.dart / app.dart / bootstrap.dart
├── config/
│   ├── theme.dart       ← AppTheme (색상·텍스트스타일)
│   ├── router.dart      ← routerProvider (GoRouter)
│   └── providers.dart
└── features/
    ├── common/
    │   ├── application/     ← instagram_controller, youtube_controller (riverpod_generator)
    │   ├── domain/          ← datasources, failures (freezed)
    │   ├── infrastructure/  ← entities, repositories
    │   ├── presentation/
    │   │   ├── screens/     ← home_screen
    │   │   ├── widgets/     ← nav_bar, hero_slider, feature_cards_section,
    │   │   │                   instagram_grid_section, fid_section,
    │   │   │                   youtube_feed_section, footer_cta_section,
    │   │   │                   site_footer, image_viewer_popup, youtube_card...
    │   │   └── providers/
    │   └── utils/           ← constants.dart, responsive.dart, utils.dart
    ├── about/               ← about_screen, fidp_screen + 위젯들
    ├── class/               ← class_screen, regular_course_screen, ourora8_screen
    ├── membership/          ← membership_screen + 위젯들
    ├── contact/             ← contact_screen + 위젯들
    └── works/               ← works_screen
```

---

## 라우트

| path | screen |
|------|--------|
| `/` | HomeScreen |
| `/about` | AboutScreen |
| `/fidp` | FIDPScreen |
| `/works` | WorksScreen |
| `/class` | ClassScreen |
| `/class/regular` | RegularCourseScreen |
| `/class/ourora8` | Ourora8Screen |
| `/membership` | MembershipScreen |
| `/contact` | ContactScreen |

전체 `ShellRoute` → `SelectionArea`로 감싸짐.

---

## AppTheme 색상 토큰

```dart
// lib/config/theme.dart
black       = Color(0xFF000000)
white       = Color(0xFFFFFFFF)
lightGray   = Color(0xFFF7F7F7)
textGray    = Color(0xFF555555)
lineGray    = Color(0xFF3A3A3A)
borderGray  = Color(0xFFDDDDDD)
darkBg      = Color(0xFF2F2E2E)
accentOrange= Color(0xFFF28241)
red         = Color(0xFFF80000)
coral       = Color(0xFFFF6161)   // 호버 강조 / 멤버십 자유반 카드
rosewood    = Color(0xFFB08484)   // 멤버십 연구반 카드
transparent = Color(0x00000000)
```

- `Colors.white/black/transparent` 직접 사용 금지 → `AppTheme.*` 사용
- 불투명도 변형은 `.withValues(alpha: 0.xx)` 사용 (`.withOpacity` deprecated)

---

## 반응형 브레이크포인트

```dart
// lib/features/common/utils/responsive.dart
mobile  < 768px
tablet  768 ~ 1199px
desktop >= 1200px
```

---

## 폰트

| 용도 | 패밀리 |
|------|--------|
| 영문 네비/타이틀 | Raleway (asset) |
| 섹션 타이틀 | Montserrat (google_fonts) |
| 한글 본문 | NanumGothic (asset) |
| 페이지 타이틀 | BMHanna (asset) |
| 영문 굵은 로고 | ArialBlack (asset) |
| 한글 보조 | Noto Sans KR (google_fonts) |

---

## 주요 데이터 소스

**Instagram**
- `InstagramRepository`: Instagram Graph API (`/media`) 직접 호출
- 페이지당 9개, cursor 기반 페이지네이션
- VIDEO 타입 필터링, `media_url` null 제외
- 토큰: `instagram_repository.dart` 내 `_accessToken` 하드코딩 (교체 필요)

**YouTube**
- `YoutubeRepository`: 영상 ID 하드코딩 또는 API 응답
- 썸네일: `https://img.youtube.com/vi/{id}/hqdefault.jpg`

---

## 홈 페이지 섹션 순서

```
NavBar (SliverPersistentHeader, pinned)
HeroSlider          — carousel_slider, 전체화면, 4초 자동재생
FeatureCardsSection — WORKSHOP / WORKS / CLASS / MEMBERSHIP
InstagramGridSection — 3열 그리드, Load More
FidSection          — F·I·D·P 4열
YoutubeFeedSection  — 가로 스크롤 카드
FooterCtaSection    — 그라데이션 배경 CTA
SiteFooter          — 주소·연락처·저작권
```

---

## 연락처 상수 (AppConstants)

```dart
email   = 'contact@ourora.com'
phone   = '010-7586-8765'
address = 'B1 6 Mokdong-ro21Gil, Yangcheon-gu, Seoul, Korea.'
horizontalPadding = EdgeInsets.symmetric(horizontal: 120)
```

---

## 에셋 목록

```
assets/images/   hero_1~4.webp, logo.png, about_background.webp,
                 footer_cta_background.webp, fidp_background.webp,
                 regular_course_background.webp, expert_course_background.webp,
                 machine_list.webp, ourora8_course.png, ourora8_logo.webp,
                 regular_course_timetable.png, course_1_1~3_1.png
assets/svgs/     icon_workshop/works/class/membership.svg,
                 ourora_membership_logo.svg, regular_course.svg
assets/videos/   about_background.mp4
assets/fonts/    NanumGothic.otf, BMHanna.otf, arial_black.ttf
```

---

## 코드 생성

모델/컨트롤러 변경 후 실행:
```bash
dart run build_runner build --delete-conflicting-outputs
```

대상 파일: `*.freezed.dart`, `*.g.dart`

---

## 실행

```bash
flutter run -d chrome
flutter build web
```
