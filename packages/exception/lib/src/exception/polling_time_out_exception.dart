import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';

class PollingTimeOutException extends CoreException {
  PollingTimeOutException({
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
  String get code => generatedCode(code: ExceptionCode.pollingTimeOut.code);

  @override
  String get message => "Polling Timeout Exception";

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