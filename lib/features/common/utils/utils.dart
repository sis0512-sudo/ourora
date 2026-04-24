// 여러 기능에서 공통으로 사용하는 범용 유틸리티 함수 모음.
import 'dart:html' as html;

import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_detail_body.dart';

class Utils {
  // 문자열의 각 글자 사이에 ZWJ(폭 없는 결합 문자, U+200D)를 삽입합니다.
  // 한글 자동 줄바꿈 방지 또는 글자 간격 조절이 필요할 때 사용합니다.
  static String formatText(String text) {
    return text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
  }

  // API 호출 등에서 발생한 에러를 로그로 출력하고 Either.left(Failure)를 반환합니다.
  // Either는 성공(Right)과 실패(Left) 중 하나를 담는 함수형 컨테이너입니다.
  static Either<Failure, R> debugLeft<R>(Object error) {
    Logger().e(error, stackTrace: StackTrace.current);
    return left(Failure.badRequest(StackTrace.current, error.toString()));
  }

  // 현재 페이지 URL을 SNS 또는 클립보드로 공유합니다.
  // [type]에 따라 Facebook / X(트위터) / LinkedIn / 링크복사 중 하나를 실행합니다.
  static void shareUrl(String url, ShareType type) {
    switch (type) {
      case ShareType.facebook:
        final shareUrl = 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}';
        html.window.open(shareUrl, '_blank'); // 새 탭에서 공유 페이지 열기
      case ShareType.x:
        final xUrl = 'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(url)}';
        html.window.open(xUrl, '_blank');
      case ShareType.linkedin:
        final linkedinUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(url)}';
        html.window.open(linkedinUrl, '_blank');
      case ShareType.copy:
        // 클립보드에 URL을 복사합니다.
        html.window.navigator.clipboard?.writeText(url);
    }
  }
}
