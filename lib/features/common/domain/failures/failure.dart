import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure implements Exception {
  const Failure._();

  const factory Failure.empty(StackTrace stackTrace, [String? message]) = _EmptyFailure;
  const factory Failure.unprocessableEntity(StackTrace stackTrace, {required String message}) = _UnprocessableEntityFailure;
  const factory Failure.unauthorized(StackTrace stackTrace, [String? message]) = _UnauthorizedFailure;
  const factory Failure.badRequest(StackTrace stackTrace, [String? message]) = _BadRequestFailure;

  String get error => this is _UnprocessableEntityFailure ? (this as _UnprocessableEntityFailure).message : '$this';
}
