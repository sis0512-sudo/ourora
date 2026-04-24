// API 호출이나 데이터 처리 중 발생하는 실패(에러) 상태를 나타내는 sealed 클래스.
// freezed 패키지로 자동 생성된 코드(failure.freezed.dart)와 함께 동작합니다.
// 사용법: Either<Failure, T> 타입으로 성공/실패를 표현합니다.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

// @freezed: 이 클래스의 불변(immutable) 서브타입들을 자동 생성합니다.
// implements Exception: try-catch에서 catch할 수 있는 예외 타입이 됩니다.
@freezed
abstract class Failure with _$Failure implements Exception {
  const Failure._();

  // 데이터가 비어있을 때의 실패 (예: 빈 목록 응답)
  const factory Failure.empty(StackTrace stackTrace, [String? message]) = _EmptyFailure;

  // 요청 형식은 맞지만 처리할 수 없는 데이터일 때 (422 Unprocessable Entity)
  const factory Failure.unprocessableEntity(StackTrace stackTrace, {required String message}) = _UnprocessableEntityFailure;

  // 인증이 필요하거나 권한이 없을 때 (401 Unauthorized)
  const factory Failure.unauthorized(StackTrace stackTrace, [String? message]) = _UnauthorizedFailure;

  // 잘못된 요청일 때 (400 Bad Request). 일반적인 에러 처리에 주로 사용됩니다.
  const factory Failure.badRequest(StackTrace stackTrace, [String? message]) = _BadRequestFailure;

  // UI에 표시할 에러 메시지를 반환합니다.
  // UnprocessableEntity는 별도의 message 필드를 사용하고, 나머지는 toString()을 사용합니다.
  String get error => this is _UnprocessableEntityFailure ? (this as _UnprocessableEntityFailure).message : '$this';
}
