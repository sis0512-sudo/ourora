import 'package:flutter/material.dart';

class FeatureCardData {
  final String title;
  final String subtitle;
  final String desc;
  final String route;

  const FeatureCardData({required this.title, required this.subtitle, required this.desc, required this.route});
}

class HeroSlide {
  final String subtitle;
  final String title;
  final String imageUrl;
  final MainAxisAlignment mainAxisAlignment;

  const HeroSlide({required this.subtitle, required this.title, required this.imageUrl, this.mainAxisAlignment = MainAxisAlignment.end});
}

class AppConstants {
  // Hero 슬라이더 텍스트
  static const List<HeroSlide> heroSlides = [
    HeroSlide(
      subtitle: 'All good things which exist are',
      title: 'THE FRUITS OF\nORIGINALITY',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fhero_1.webp?alt=media&token=fdd07a8b-0257-42e4-a552-27c77b43fbed',
      mainAxisAlignment: MainAxisAlignment.end,
    ),
    HeroSlide(
      subtitle: 'Make',
      title: 'IT HAPPEN',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fhero_2.webp?alt=media&token=90ba36bd-62eb-4c34-8bd2-3d8bad21b24b',
      mainAxisAlignment: MainAxisAlignment.start,
    ),
    HeroSlide(
      subtitle: 'Show me',
      title: 'YOUR STORY',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fhero_3.webp?alt=media&token=a759f2da-51d7-4adf-b29b-90957221c8d6',
      mainAxisAlignment: MainAxisAlignment.start,
    ),
    HeroSlide(
      subtitle: 'It\'s',
      title: 'YOUR PLACE',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fhero_4.webp?alt=media&token=847795f9-f7a1-4212-a075-3e454ac8a86e',
      mainAxisAlignment: MainAxisAlignment.center,
    ),
  ];

  // FID 섹션 데이터
  static const List<Map<String, String>> fidItems = [
    {'letter': 'F', 'title': 'FURNITURE', 'desc': '나무로 가구를 만드는 가구공방입니다. 물론 다른 것들도 만듭니다.'},
    {'letter': 'I', 'title': 'IT CONVERGENCE', 'desc': '가구와 IT 기술과의 융합을 통한 새로운 디자인 가능성을 모색합니다.'},
    {'letter': 'D', 'title': 'DESIGN', 'desc': '디자인에 대한 폭넓은 이해와 깊이로 진정성있는 디자인을 고민합니다.'},
    {'letter': 'P', 'title': 'PEOPLE', 'desc': '누구나 참여할 수 있는 다양한 가구제작 수업과 워크숍이 있습니다.'},
  ];

  // 연락처
  static const String email = 'contact@ourora.com';
  static const String phone = '010-7586-8765';
  static const String address = 'B1 6 Mokdong-ro21Gil, Yangcheon-gu, Seoul, Korea.';
  static const String copyright = '© 2021 OURORA STUDIO. All rights reserved.';

  // Instagram OAuth 설정
  static const String instagramAppId = '17841460854096384'; // Instagram App ID 입력
  static const String instagramRedirectUri = 'https://ourorastudio.com/auth'; // 실제 redirect URI 입력

  // 유튜브 URL 헬퍼
  static String thumbnailUrl(String videoId) => 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  static String videoUrl(String videoId) => 'https://www.youtube.com/watch?v=$videoId';

  static EdgeInsetsGeometry get horizontalPadding => const EdgeInsets.symmetric(horizontal: 120);

  static String firestoreDatabaseId = 'ourora';
  static String firebaseFunctionsRegion = 'asia-northeast3';
}
