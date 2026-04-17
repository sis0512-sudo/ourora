# CLAUDE.md — OURORA STUDIO Flutter 프로젝트

## 프로젝트 개요

이 프로젝트는 https://www.ourorastudio.com/ 을 Flutter Web으로 완전히 재현하는 것이 목표입니다.
가구공방 오로라스튜디오의 홈페이지로, 단일 스크롤 랜딩 페이지 구조입니다.

---

## 기술 스택

- **Flutter 3.x** (Web 타겟)
- **Dart 3.x**
- 주요 패키지 (`pubspec.yaml` 기준):
```yaml
dependencies:
  go_router: ^17.0.0
  carousel_slider: ^5.0.0
  cached_network_image: ^3.4.1
  responsive_framework: ^1.4.0
  google_fonts: ^6.2.0
  url_launcher: ^6.3.1
  flutter_riverpod: ^3.0.3
  freezed_annotation: ^3.1.0
```

---

## 페이지 구조

홈페이지는 단일 스크롤 페이지이며, 아래 섹션 순서로 구성된다:

1. NavBar (상단 고정)
2. Hero Slider (전체화면 이미지 슬라이더)
3. Feature Cards (WORKSHOP / WORKS / CLASS / MEMBERSHIP)
4. Instagram Photo Grid (3열 사진 그리드 + Load More)
5. FID Section ("오로라 공방은?" + F·I·D·P 4열)
6. YouTube Feed (가로 스크롤 영상 카드)
7. Footer CTA (그라데이션 배경 + 슬로건)
8. Footer (저작권 / 주소 / 연락처 / 로고)

---

## 디렉토리 구조

nihongo 프로젝트와 동일한 feature-based DDD 구조를 사용한다:
```
lib/
├── main.dart
├── app.dart
├── bootstrap.dart
├── config/
│   ├── router.dart          ← GoRouter (routerProvider)
│   ├── theme.dart           ← AppTheme 클래스
│   └── providers.dart       ← 글로벌 Provider
├── dependency/              ← 외부 의존성 래퍼
└── features/
    └── common/
        ├── presentation/
        │   ├── screens/
        │   │   ├── home_screen.dart
        │   │   ├── about_screen.dart
        │   │   ├── works_screen.dart
        │   │   ├── class_screen.dart
        │   │   └── membership_screen.dart
        │   └── widgets/
        │       ├── nav_bar.dart
        │       ├── hero_slider.dart
        │       ├── feature_cards_section.dart
        │       ├── instagram_grid_section.dart
        │       ├── fid_section.dart
        │       ├── youtube_feed_section.dart
        │       ├── footer_cta_section.dart
        │       └── site_footer.dart
        └── utils/
            ├── constants.dart   ← AppConstants (데이터, URL 헬퍼)
            └── responsive.dart  ← Responsive (브레이크포인트)

assets/
├── images/
│   ├── logo.png
│   ├── hero_1.webp ~ hero_4.webp
└── icons/
    ├── icon_workshop.svg
    ├── icon_works.svg
    ├── icon_class.svg
    └── icon_membership.svg
```

---

## 디자인 토큰 (core/theme.dart)
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 색상
  static const Color black       = Color(0xFF111111);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color lightGray   = Color(0xFFF7F7F7);
  static const Color textGray    = Color(0xFF555555);
  static const Color borderGray  = Color(0xFFDDDDDD);

  // Footer CTA 그라데이션 (핑크 → 보라 → 연파랑)
  static const LinearGradient footerGradient = LinearGradient(
    colors: [
      Color(0xFFF4A7B9),
      Color(0xFFCE93D8),
      Color(0xFF90CAF9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 타이포그래피
  static TextStyle navItem() => GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: black,
  );

  static TextStyle heroSubtitle() => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );

  static TextStyle heroTitle() => GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 2,
    height: 1.1,
  );

  static TextStyle sectionTitle() => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 3,
    color: black,
  );

  static TextStyle bodyKorean() => GoogleFonts.notoSansKr(
    fontSize: 14,
    height: 1.8,
    color: textGray,
  );

  static TextStyle footerCtaTitle() => GoogleFonts.montserrat(
    fontSize: 60,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 4,
  );

  static TextStyle footerCtaSubtitle() => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    letterSpacing: 3,
  );
}
```

---

## 반응형 브레이크포인트 (core/responsive.dart)
```dart
import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int gridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 3;
  }

  static int featureColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 4;
  }
}
```

---

## 상수 (core/constants.dart)
```dart
class AppConstants {
  // 유튜브 채널 ID (오로라스튜디오 유튜브)
  static const String youtubeChannelId = 'UCxxxxxxxxxxxxxx'; // 실제 채널 ID 입력

  // 유튜브 영상 ID 목록 (하드코딩 또는 API로 대체)
  static const List<String> youtubeVideoIds = [
    'VIDEO_ID_1',
    'VIDEO_ID_2',
    'VIDEO_ID_3',
    'VIDEO_ID_4',
  ];

  // 영상 제목 목록 (youtubeVideoIds와 순서 일치)
  static const List<String> youtubeTitles = [
    'OURORA STUDIO - #공방일상 : 밀대와 수압대패에 가죽 붙이기',
    'OURORA STUDIO - 작업대용 긴 스툴 만들기 Making a long stool for workbench',
    'OURORA STUDIO - FESTOOL 페스툴 라우터 OF 2200 사용방법 소개',
    'OURORA STUDIO - 테이블쏘 썰매 지그 만들기 Making a Sled jig for Table saw',
  ];

  // 영상 길이 표시 문자열
  static const List<String> youtubeDurations = [
    '08:17',
    '20:28',
    '28:42',
    '21:17',
  ];

  // Hero 슬라이더 텍스트
  static const List<Map<String, String>> heroSlides = [
    {
      'subtitle': 'All good things which exist are',
      'title': 'THE FRUITS OF\nORIGINALITY',
      'image': 'assets/images/hero_1.jpg',
    },
    {
      'subtitle': 'Make it happen',
      'title': 'WORKSHOP',
      'image': 'assets/images/hero_2.jpg',
    },
    {
      'subtitle': 'Craft with passion',
      'title': 'YOUR OWN\nCREATION',
      'image': 'assets/images/hero_3.jpg',
    },
    {
      'subtitle': 'Join our community',
      'title': 'MAKE IT\nHAPPEN',
      'image': 'assets/images/hero_4.jpg',
    },
  ];

  // Feature Cards 데이터
  static const List<Map<String, String>> featureCards = [
    {
      'icon': 'assets/icons/icon_workshop.svg',
      'title': 'WORKSHOP',
      'subtitle': '공방 소개',
      'desc': '공방에 대한 소개와 문화, 그리고 추구하는 목표와 방향을 이야기합니다.',
      'route': '/about',
    },
    {
      'icon': 'assets/icons/icon_works.svg',
      'title': 'WORKS',
      'subtitle': '작품과 작업들',
      'desc': '오로라공방 구성원분들이 제작한 작품들과 작업들을 소개합니다.',
      'route': '/works',
    },
    {
      'icon': 'assets/icons/icon_class.svg',
      'title': 'CLASS',
      'subtitle': '다양한 목공 수업',
      'desc': '가구 디자인 및 목공 기술을 배울 수 있는 전문적인 수업에 참여하실 수 있습니다.',
      'route': '/class',
    },
    {
      'icon': 'assets/icons/icon_membership.svg',
      'title': 'MEMBERSHIP',
      'subtitle': '공방 자유이용',
      'desc': '개인 작품활동, 지속적인 취미목공 등을 위해 공방을 자유롭게 이용할 수 있습니다.',
      'route': '/membership',
    },
  ];

  // FID 섹션 데이터
  static const List<Map<String, String>> fidItems = [
    {
      'letter': 'F',
      'title': 'FURNITURE',
      'desc': '나무로 가구를 만드는 가구공방입니다. 물론 다른 것들도 만듭니다.',
    },
    {
      'letter': 'I',
      'title': 'IT CONVERGENCE',
      'desc': '가구와 IT 기술과의 융합을 통한 새로운 디자인 가능성을 모색합니다.',
    },
    {
      'letter': 'D',
      'title': 'DESIGN',
      'desc': '디자인에 대한 폭넓은 이해와 깊이로 진정성있는 디자인을 고민합니다.',
    },
    {
      'letter': 'P',
      'title': 'PEOPLE',
      'desc': '누구나 참여할 수 있는 다양한 가구제작 수업과 워크숍이 있습니다.',
    },
  ];

  // 연락처
  static const String email = 'contact@ourora.com';
  static const String phone = '010-7586-8765';
  static const String address = 'B1 6 Mokdong-ro21Gil, Yangcheon-gu, Seoul, Korea.';
  static const String copyright = '© 2021 OURORA STUDIO. All rights reserved.';
}
```

---

## 섹션별 구현 명세

### 1. NavBar (widgets/nav_bar.dart)

- 배경: 흰색, 하단 border 없음 (원본은 매우 얇은 그림자)
- 좌측: "OURORA\nSTUDIO" 텍스트 로고 (굵은 sans-serif, 2줄, 검정색)
- 우측: ABOUT / WORKS / CLASS / MEMBERSHIP 메뉴 (대문자, 자간 넓게)
- 모바일: 햄버거 메뉴로 대체
- `SliverAppBar`로 구현하여 스크롤 시 상단 고정
```dart
// 로고 텍스트 스타일 예시
Text(
  'OURORA\nSTUDIO',
  style: GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    height: 1.1,
    color: Colors.black,
  ),
)
```

---

### 2. Hero Slider (widgets/hero_slider.dart)

- `carousel_slider` 패키지 사용
- 뷰포트 100% 높이 (화면 전체)
- 자동재생: 4초 간격
- 좌/우 화살표 버튼 (반투명 흰색 원형)
- 하단 도트 인디케이터 (활성: 흰색 원, 비활성: 반투명 원)
- 이미지 위에 어두운 오버레이 (opacity 0.2~0.3)
- 텍스트는 우하단 정렬: 이탤릭 소자막 → 큰 bold 제목
```dart
CarouselOptions(
  height: MediaQuery.of(context).size.height,
  viewportFraction: 1.0,
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 4),
  autoPlayAnimationDuration: Duration(milliseconds: 800),
  autoPlayCurve: Curves.easeInOut,
  enableInfiniteScroll: true,
)
```

---

### 3. Feature Cards (widgets/feature_cards_section.dart)

- 배경: 흰색
- 상단 여백: 80px, 하단 여백: 80px
- 카드 레이아웃: 반응형 (모바일 1열, 태블릿 2열, 데스크탑 4열)
- 각 카드 구성:
  - 아이콘 이미지 (검정 선화 스타일, 60x60)
  - 영문 제목 (대문자, 굵게, 자간 넓게)
  - 한글 소제목
  - 한글 설명 텍스트 (center 정렬)
  - "Read More >" 링크 텍스트 (하단)
- 카드 사이 구분선 없음

---

### 4. Instagram Photo Grid (widgets/instagram_grid_section.dart)

- 배경: 흰색
- 3열 정방형 그리드, 간격 4px
- 초기 6장 표시, "Load More" 버튼 클릭 시 추가 로드
- "Load More" 버튼: border 있는 outline 스타일, 중앙 정렬
- 이미지는 `CachedNetworkImage` 사용, `BoxFit.cover`
- 실제 이미지는 asset 또는 Firebase Storage URL 사용
```dart
// Load More 버튼 스타일
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.black),
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  onPressed: () { /* 추가 이미지 로드 */ },
  child: Text('Load More', style: AppTheme.navItem()),
)
```

---

### 5. FID Section (widgets/fid_section.dart)

- 배경: 흰색
- 상단: "오로라 공방은?" 텍스트 (중앙 정렬, 한글, 자간 넓게) + 하단에 짧은 가로 구분선
- 4열 레이아웃 (모바일에서는 2열 or 1열로 축소)
- 각 항목:
  - 대형 알파벳 1자 (F/I/D/P) — 매우 크게, 굵게 (fontSize: 120)
  - 영문 타이틀 (대문자, 굵게)
  - 한글 설명 (center 정렬)
- 하단에 "Read More >>" 버튼 (중앙, outline 스타일)

---

### 6. YouTube Feed (widgets/youtube_feed_section.dart)

- 섹션 상단: "⠿ Youtube Feed" 라벨 (좌측 정렬)
- 가로 스크롤 ListView
- 각 카드 (width: 320px):
  - 썸네일 이미지 (youtube thumbnail URL 사용)
  - 재생 버튼 오버레이 (중앙 원형 흰색 아이콘)
  - 우상단 영상 길이 표시
  - 하단 제목 텍스트 (2줄 제한)
  - 설명 미리보기 텍스트 (3줄 제한, 말줄임)
- 썸네일 URL 패턴: `https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg`
- 카드 클릭 시 `url_launcher`로 유튜브 링크 열기
```dart
// YouTube 썸네일 URL
String thumbnailUrl(String videoId) =>
  'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

// YouTube 영상 링크
String videoUrl(String videoId) =>
  'https://www.youtube.com/watch?v=$videoId';
```

---

### 7. Footer CTA (widgets/footer_cta_section.dart)

- 배경: 핑크→보라→연파랑 그라데이션 (LinearGradient)
- 높이: 500px
- 중앙 정렬 텍스트:
  - "YOUR OWN LIGHT" — 매우 크게 (fontSize: 60~80), 흰색, bold
  - "MAKE YOU SHINE IN THE WORLD" — 중간 크기, 흰색 반투명, 자간 넓게
  - "Read More >>" 링크 (하단, 흰색 outline 버튼)

---

### 8. Site Footer (widgets/site_footer.dart)

- 배경: 흰색
- 3열 레이아웃 (모바일: 세로 스택):
  - 좌: "© 2021 OURORA STUDIO. All rights reserved."
  - 중: 주소 "B1 6 Mokdong-ro21Gil, Yangcheon-gu, Seoul, Korea."
  - 우: 이메일 / 전화번호
- 하단: OURORA STUDIO 텍스트 로고 (흰 배경에 검정)

---

## 라우팅 (app.dart)

`go_router`를 사용하여 다음 라우트를 설정할 것:
```dart
final router = GoRouter(routes: [
  GoRoute(path: '/',          builder: (ctx, state) => HomePage()),
  GoRoute(path: '/about',     builder: (ctx, state) => AboutPage()),
  GoRoute(path: '/works',     builder: (ctx, state) => WorksPage()),
  GoRoute(path: '/class',     builder: (ctx, state) => ClassPage()),
  GoRoute(path: '/membership',builder: (ctx, state) => MembershipPage()),
]);
```

---

## main.dart 구조
```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '가구공방 오로라공방 | OURORA STUDIO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Noto Sans KR',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      routerConfig: router,
    );
  }
}
```

---

## HomePage 스크롤 구조
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. 상단 고정 NavBar
          SliverPersistentHeader(
            delegate: NavBarDelegate(),
            pinned: true,
          ),
          // 2~8. 각 섹션을 SliverToBoxAdapter로 감싸기
          SliverToBoxAdapter(child: HeroSlider()),
          SliverToBoxAdapter(child: FeatureCardsSection()),
          SliverToBoxAdapter(child: InstagramGridSection()),
          SliverToBoxAdapter(child: FidSection()),
          SliverToBoxAdapter(child: YoutubeFeedSection()),
          SliverToBoxAdapter(child: FooterCtaSection()),
          SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
```

---

## pubspec.yaml assets 설정
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: NotoSansKR
      fonts:
        - asset: assets/fonts/NotoSansKR-Regular.ttf
          weight: 400
        - asset: assets/fonts/NotoSansKR-Bold.ttf
          weight: 700
```

---

## 구현 현황

기본 구조 완성. 아래 파일들이 생성되어 있음:

| 파일 | 상태 |
|------|------|
| `pubspec.yaml` | 완료 |
| `lib/config/theme.dart` | 완료 (AppTheme) |
| `lib/features/common/utils/responsive.dart` | 완료 |
| `lib/features/common/utils/constants.dart` | 완료 |
| `lib/main.dart` + `lib/app.dart` + `lib/bootstrap.dart` | 완료 |
| `lib/config/router.dart` | 완료 (5개 라우트) |
| `lib/features/common/presentation/widgets/nav_bar.dart` | 완료 |
| `lib/features/common/presentation/widgets/hero_slider.dart` | 완료 |
| `lib/features/common/presentation/widgets/feature_cards_section.dart` | 완료 |
| `lib/features/common/presentation/widgets/instagram_grid_section.dart` | 완료 |
| `lib/features/common/presentation/widgets/fid_section.dart` | 완료 |
| `lib/features/common/presentation/widgets/youtube_feed_section.dart` | 완료 |
| `lib/features/common/presentation/widgets/footer_cta_section.dart` | 완료 |
| `lib/features/common/presentation/widgets/site_footer.dart` | 완료 |
| `lib/features/common/presentation/screens/home_screen.dart` | 완료 |
| `lib/features/common/presentation/screens/about_screen.dart` | 스캐폴드 |
| `lib/features/common/presentation/screens/works_screen.dart` | 스캐폴드 |
| `lib/features/common/presentation/screens/class_screen.dart` | 스캐폴드 |
| `lib/features/common/presentation/screens/membership_screen.dart` | 스캐폴드 |

**남은 작업**: `assets/` 실제 이미지/아이콘 파일 추가, 각 서브 페이지 구현

---

## 주의사항

- 모든 텍스트는 원본 사이트와 동일한 한국어/영어 혼용을 유지할 것
- 색상은 원본 기준으로 흰색/검정 위주의 미니멀 팔레트
- 폰트는 `google_fonts` 패키지의 Montserrat(영문), Playfair Display(슬로건), Noto Sans KR(한글) 사용
- 실제 Instagram 이미지와 YouTube 영상 ID는 플레이스홀더로 처리 후 나중에 교체
- `flutter run -d chrome`으로 웹 실행 테스트
- 각 위젯은 독립적으로 테스트 가능하도록 더미 데이터 포함