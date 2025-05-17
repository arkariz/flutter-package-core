import 'package:exception/exception.dart';

class PermissionDeniedException extends CoreException {
  PermissionDeniedException({
    required this.module,
    required this.layer,
    required this.function,
    this.stackTrace,
  });

  @override
  String module;

  @override
  String get code => generatedCode(code: ExceptionCode.permissionDenied.code);

  @override
  String function;

  @override
  String layer;

  @override
  String? get message => "Permission Denied";

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
