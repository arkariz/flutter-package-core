import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';

class UploadInProgressException extends CoreException {
  UploadInProgressException({
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
  String get code => generatedCode(code: ExceptionCode.uploadInProgress.code);

  @override
  String get message => "Upload In Progress Exception";

  @override
  Object? stackTrace;

  @override

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? "",
      description: "Terjadi kesalahan pada proses $function $code",
      type: type,
    );
  }
}