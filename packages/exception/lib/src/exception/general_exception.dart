import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';
import 'package:exception/src/model/exception_rule.dart';

class GeneralException extends CoreException {
  GeneralException({
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
  String get code => generatedCode(code: ExceptionCode.general.code);

  @override
  String get message => "General Exception";

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

  static ExceptionRule rule({
    required String module,
    required String layer,
    required String function,
    Object? stackTrace,
  }) => ExceptionRule(
    predicate: (exception) => true,
    transformer:
      (exception) => GeneralException(
        module: module,
        layer: layer,
        function: function,
        stackTrace: stackTrace,
      ),
  );
}
