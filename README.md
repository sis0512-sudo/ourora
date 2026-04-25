# OURORA STUDIO — 홈페이지

가구공방 오로라스튜디오 공식 홈페이지. Flutter Web으로 만든 멀티페이지 웹사이트입니다.

---

## 목차

1. [기술 스택](#기술-스택)
2. [개발 환경 설정](#개발-환경-설정)
3. [프로젝트 구조](#프로젝트-구조)
4. [페이지 구성](#페이지-구성)
5. [데이터 연동](#데이터-연동)
6. [Firebase 설정](#firebase-설정)
7. [코드 생성](#코드-생성)
8. [배포](#배포)
9. [주요 설계 원칙](#주요-설계-원칙)
10. [자주 하는 작업](#자주-하는-작업)

---

## 기술 스택

| 분류 | 패키지 |
|------|--------|
| 프레임워크 | Flutter 3.x / Dart 3.x (Web) |
| 상태관리 | `flutter_riverpod` + `riverpod_generator` |
| 라우팅 | `go_router` |
| 데이터 모델 | `freezed` + `fpdart` |
| HTTP | `http` (Instagram Graph API, YouTube API) |
| Firebase | `cloud_firestore`, `cloud_functions`, `firebase_storage` |
| UI | `carousel_slider`, `flutter_svg`, `responsive_framework`, `auto_size_text` |
| 폰트 | Google Fonts (Raleway, Montserrat, Noto Sans KR) + 에셋 폰트 (BMHanna, ArialBlack) |

---

## 개발 환경 설정

### 1. Flutter 설치

[flutter.dev](https://flutter.dev/docs/get-started/install) 에서 Flutter SDK를 설치합니다.

```bash
flutter --version   # 3.x 이상 확인
```

### 2. Firebase CLI 설치

```bash
npm install -g firebase-tools
firebase login
```

### 3. 의존성 설치

```bash
flutter pub get
```

### 4. 로컬 개발 서버 실행

```bash
flutter run -d chrome
```

---

## 프로젝트 구조

```
ourora/
├── lib/
│   ├── main.dart            ← 앱 진입점
│   ├── app.dart             ← MaterialApp 설정
│   ├── bootstrap.dart       ← Firebase 초기화
│   ├── config/
│   │   ├── theme.dart       ← AppTheme (색상·텍스트 스타일 중앙 관리)
│   │   └── router.dart      ← 전체 라우팅 설정 (go_router)
│   └── features/
│       ├── common/          ← 공통 기능 (네비게이션, 홈, 인스타그램, 유튜브)
│       ├── about/           ← 소개 페이지
│       ├── class/           ← 수업 안내 페이지
│       ├── membership/      ← 멤버십 페이지
│       ├── contact/         ← 문의 페이지
│       └── works/           ← 작품 갤러리 (Firestore 연동)
├── functions/               ← Firebase Cloud Functions (TypeScript)
│   └── src/index.ts         ← YouTube API, Instagram API 프록시
├── assets/
│   ├── images/              ← webp 이미지 (hero, 배경 등)
│   ├── svgs/                ← 아이콘 SVG
│   └── fonts/               ← BMHanna.otf, arial_black.ttf
├── deploy.sh                ← 배포 스크립트
└── DEPLOY_LOG.md            ← 배포 이력 (deploy.sh가 자동 기록)
```

각 feature 디렉토리는 아래 4개 레이어로 구성됩니다:

```
features/works/
├── application/     ← Riverpod 컨트롤러 (상태·비즈니스 로직)
├── domain/          ← 도메인 모델(WorkItem), 추상 인터페이스
├── infrastructure/  ← 실제 Firebase 구현체 (Firestore, Storage)
└── presentation/
    ├── screens/     ← 페이지 전체를 구성하는 최상위 위젯
    └── widgets/     ← 페이지를 구성하는 하위 위젯 조각들
```

---

## 페이지 구성

| URL 경로 | 화면 | 설명 |
|----------|------|------|
| `/` | HomeScreen | 메인 홈 (슬라이더, 피처카드, 인스타그램, 유튜브 등) |
| `/about` | AboutScreen | 공방 소개 |
| `/fidp` | FIDPScreen | F·I·D·P 프로그램 소개 |
| `/works` | WorksScreen | 작품 갤러리 (Firestore) |
| `/post/:id` | WorkPostScreen | 작품 상세 페이지 |
| `/class` | ClassScreen | 수업 안내 |
| `/class/regular` | RegularCourseScreen | 정규 과정 |
| `/class/ourora8` | Ourora8Screen | OURORA 8 프로그램 |
| `/membership` | MembershipScreen | 멤버십 안내 |
| `/contact` | ContactScreen | 문의하기 |

### 홈 페이지 섹션 순서

```
NavBar (상단 고정)
HeroSlider          — 전체화면 이미지 슬라이더 (4초 자동재생)
FeatureCardsSection — WORKSHOP / WORKS / CLASS / MEMBERSHIP 카드
InstagramGridSection — 3열 인스타그램 피드, 더보기 버튼
FidSection          — F·I·D·P 4열 소개
YoutubeFeedSection  — 가로 스크롤 유튜브 카드
FooterCtaSection    — 하단 CTA 배너
SiteFooter          — 주소·연락처·저작권
```

---

## 데이터 연동

### Instagram

- **경로:** Cloud Functions → Instagram Graph API
- **함수명:** `fetchInstagramPostsCallable` (`functions/src/index.ts`)
- **토큰 관리:** Firebase Secret Manager의 `INSTAGRAM_ACCESS_TOKEN` 시크릿에 저장
- **페이지네이션:** 9개씩, cursor 기반
- **필터:** VIDEO 타입 및 `media_url` 없는 항목 제외

토큰 갱신이 필요할 때:
```bash
firebase functions:secrets:set INSTAGRAM_ACCESS_TOKEN
```

### YouTube

- **경로:** Cloud Functions → YouTube Data API v3
- **함수명:** `fetchYoutubeVideosCallable` (`functions/src/index.ts`)
- **API 키 관리:** Firebase Secret Manager의 `YOUTUBE_API_KEY` 시크릿에 저장

### Works (작품 갤러리)

- **데이터베이스:** Firestore (`ourora` 데이터베이스, `asia-northeast3` 리전)
- **컬렉션:** `works`
- **이미지 저장:** Firebase Storage (`works/{id}/image_0.webp` 형태)
- **업로드 기능:** `WorksUploadSection` 위젯 (관리자 전용, 비밀번호 보호)

Firestore 문서 구조:
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "imageUrls": ["string"],
  "lightImageUrls": ["string"],
  "youtubeUrl": "string | null",
  "type": "furniture | etc",
  "createdAt": "ISO 8601 string"
}
```

---

## Firebase 설정

- **프로젝트 ID:** `ourora-78e54`
- **Firestore DB ID:** `ourora` (기본 `(default)` 아님 — 주의)
- **Cloud Functions 리전:** `asia-northeast3` (서울)
- **Hosting 소스:** `build/web`

### 시크릿 목록

| 시크릿 이름 | 용도 |
|------------|------|
| `INSTAGRAM_ACCESS_TOKEN` | Instagram Graph API 장기 토큰 |
| `YOUTUBE_API_KEY` | YouTube Data API v3 키 |

시크릿 확인/등록:
```bash
firebase functions:secrets:access INSTAGRAM_ACCESS_TOKEN
firebase functions:secrets:set INSTAGRAM_ACCESS_TOKEN
```

---

## 코드 생성

`freezed` 모델이나 `riverpod_generator` 컨트롤러를 수정한 뒤 반드시 실행합니다:

```bash
dart run build_runner build --delete-conflicting-outputs
```

생성되는 파일: `*.freezed.dart`, `*.g.dart`

> 이 파일들은 직접 편집하지 않습니다. 원본 `.dart` 파일을 수정한 뒤 위 명령어로 재생성합니다.

---

## 배포

프로젝트 루트의 `deploy.sh` 스크립트를 사용합니다.

```bash
./deploy.sh           # patch 버전 올림 (1.0.0 → 1.0.1)  — 콘텐츠·버그 수정
./deploy.sh minor     # minor 버전 올림 (1.0.1 → 1.1.0)  — 새 기능 추가
./deploy.sh major     # major 버전 올림 (1.1.0 → 2.0.0)  — 대규모 개편
```

스크립트가 자동으로 처리하는 작업:
1. `pubspec.yaml` 버전 번호 업데이트
2. `DEPLOY_LOG.md`에 배포 날짜·버전 기록
3. `flutter build web --release` 빌드
4. `firebase deploy --only hosting` 배포
5. git commit + tag 생성

Cloud Functions를 함께 배포해야 할 때:
```bash
firebase deploy --only functions
firebase deploy   # 전체 배포 (hosting + functions + firestore rules)
```

---

## 주요 설계 원칙

### 색상 사용

`Colors.white`, `Colors.black` 대신 반드시 `AppTheme.*`을 사용합니다.

```dart
// lib/config/theme.dart
AppTheme.black       // #000000
AppTheme.white       // #FFFFFF
AppTheme.accentOrange // #F28241 — 주요 강조색
AppTheme.textGray    // #555555 — 본문 텍스트
AppTheme.borderGray  // #DDDDDD — 테두리
```

불투명도 적용:
```dart
// .withOpacity() 는 deprecated — 아래 방식 사용
color.withValues(alpha: 0.5)
```

### 반응형 브레이크포인트

```dart
// lib/features/common/utils/responsive.dart
AppConstants.windowMaxWidth = 980  // 콘텐츠 최대 너비
```

### 에러 처리

데이터 로딩은 `Either<Failure, T>` 패턴을 사용합니다. 성공은 `right()`, 실패는 `left()`로 반환하며 UI에서 `fold()`로 분기 처리합니다.

---

## 자주 하는 작업

### 히어로 이미지 교체

`assets/images/hero_1_compressed.webp` ~ `hero_4_compressed.webp` 파일을 교체합니다.
이미지는 `.webp` 형식으로 변환하고 파일명을 동일하게 유지합니다.

### 인스타그램 토큰 만료 시

Instagram 장기 토큰(60일 유효)이 만료되면 새 토큰을 발급받아 시크릿을 업데이트합니다:
```bash
firebase functions:secrets:set INSTAGRAM_ACCESS_TOKEN
firebase deploy --only functions
```

### 작품 업로드

`/works` 페이지 하단의 업로드 섹션을 사용합니다 (관리자 비밀번호 필요).
이미지는 자동으로 Firebase Storage에 저장되고 Firestore에 문서가 생성됩니다.

### 연락처·주소 변경

`lib/features/common/utils/constants.dart`의 `AppConstants` 클래스에서 수정합니다.

### OG 메타 태그 수정

`lib/features/common/utils/og_meta.dart`와 `og_updater.dart`에서 각 경로별 메타 정보를 수정합니다.
