import 'dart:html' as html;

import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_detail_body.dart';

class Utils {
  static String formatText(String text) {
    return text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
  }

  static Either<Failure, R> debugLeft<R>(Object error) {
    Logger().e(error, stackTrace: StackTrace.current);
    return left(Failure.badRequest(StackTrace.current, error.toString()));
  }

  static void shareUrl(String url, ShareType type) {
    switch (type) {
      case ShareType.facebook:
        final shareUrl = 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}';
        html.window.open(shareUrl, '_blank');
      case ShareType.x:
        final xUrl = 'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(url)}';
        html.window.open(xUrl, '_blank');
      case ShareType.linkedin:
        final linkedinUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(url)}';
        html.window.open(linkedinUrl, '_blank');
      case ShareType.copy:
        html.window.navigator.clipboard?.writeText(url);
    }
  }
}
