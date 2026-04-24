// 앱 전체에서 공통으로 사용하는 상수 값들을 모아둔 클래스.
// 문자열 리터럴을 코드 곳곳에 직접 쓰는 대신, 여기서 한 번만 정의하고 참조합니다.
class AppConstants {
  // 공방 연락처 정보
  static const String email = 'contact@ourora.com';
  static const String phone = '010-7586-8765';
  static const String address = 'B1 6 Mokdong-ro21Gil, Yangcheon-gu, Seoul, Korea.';
  static const String copyright = '© 2021 OURORA STUDIO. All rights reserved.';

  // 콘텐츠 영역의 최대 너비(px). 이 값을 초과하면 양쪽 여백이 생깁니다.
  static double get windowMaxWidth => 980;

  // Firestore 데이터베이스 ID (기본 '(default)' 대신 커스텀 DB 사용)
  static String firestoreDatabaseId = 'ourora';

  // Firebase Cloud Functions 배포 리전 (서울 리전)
  static String firebaseFunctionsRegion = 'asia-northeast3';
}
