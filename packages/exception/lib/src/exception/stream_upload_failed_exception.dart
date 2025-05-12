import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';

class StreamUploadFailedException extends CoreException {
  StreamUploadFailedException({
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
  String get code => generatedCode(code: ExceptionCode.streamUploadFailed.code);

  @override
  String get message => "Stream Upload Failed Exception";

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