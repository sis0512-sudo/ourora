class AppConstants {
  // 유튜브 채널 ID
  static const String youtubeChannelId = 'UCxxxxxxxxxxxxxx';

  // 유튜브 영상 ID 목록
  static const List<String> youtubeVideoIds = ['VIDEO_ID_1', 'VIDEO_ID_2', 'VIDEO_ID_3', 'VIDEO_ID_4'];

  // 영상 제목 목록 (youtubeVideoIds와 순서 일치)
  static const List<String> youtubeTitles = [
    'OURORA STUDIO - #공방일상 : 밀대와 수압대패에 가죽 붙이기',
    'OURORA STUDIO - 작업대용 긴 스툴 만들기 Making a long stool for workbench',
    'OURORA STUDIO - FESTOOL 페스툴 라우터 OF 2200 사용방법 소개',
    'OURORA STUDIO - 테이블쏘 썰매 지그 만들기 Making a Sled jig for Table saw',
  ];

  // 영상 길이 표시 문자열
  static const List<String> youtubeDurations = ['08:17', '20:28', '28:42', '21:17'];

  // Hero 슬라이더 텍스트
  static const List<Map<String, String>> heroSlides = [
    {'subtitle': 'All good things which exist are', 'title': 'THE FRUITS OF\nORIGINALITY', 'image': 'assets/images/hero_1.webp'},
    {'subtitle': 'Make', 'title': 'IT HAPPEN', 'image': 'assets/images/hero_2.webp'},
    {'subtitle': 'Show me', 'title': 'YOUR STORY', 'image': 'assets/images/hero_3.webp'},
    {'subtitle': 'It\'s', 'title': 'YOUR PLACE', 'image': 'assets/images/hero_4.webp'},
  ];

  // Feature Cards 데이터
  static const List<Map<String, String>> featureCards = [
    {'icon': 'assets/icons/icon_workshop.svg', 'title': 'WORKSHOP', 'subtitle': '공방 소개', 'desc': '공방에 대한 소개와 문화, 그리고 추구하는 목표와 방향을 이야기합니다.', 'route': '/about'},
    {'icon': 'assets/icons/icon_works.svg', 'title': 'WORKS', 'subtitle': '작품과 작업들', 'desc': '오로라공방 구성원분들이 제작한 작품들과 작업들을 소개합니다.', 'route': '/works'},
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

  // 유튜브 URL 헬퍼
  static String thumbnailUrl(String videoId) => 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  static String videoUrl(String videoId) => 'https://www.youtube.com/watch?v=$videoId';
}
