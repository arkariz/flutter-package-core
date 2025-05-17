import 'package:exception/exception.dart';

class RetryExceededException extends CoreException {
  RetryExceededException({
    required this.module,
    required this.layer,
    required this.function,
    this.stackTrace,
  });

  @override
  String module;

  @override
  String layer;

  @override
  String function;

  @override
  String get code => generatedCode(code: ExceptionCode.retryExceeded.code);

  @override
  String get message => "Retry Exceeded Exception";

  @override
  Object? stackTrace;

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? "",
      description: "Terjadi kesalahan pada proses $function $code",
      type: type,
    );
  }
}