import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';

class Utils {
  static String formatText(String text) {
    return text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
  }

  static Either<Failure, R> debugLeft<R>(Object error) {
    Logger().e(error, stackTrace: StackTrace.current);
    return left(Failure.badRequest(StackTrace.current, error.toString()));
  }
}
