import 'package:exception/exception.dart';
import 'package:exception/src/model/exception_rule.dart';

class DecodeFailedException extends CoreException {
  DecodeFailedException({
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
  String get code => generatedCode(code: ExceptionCode.decodeFailed.code);

  @override
  String get message => "Failed encode/decode - Mismatched Type";

  @override
  Object? stackTrace;

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? "",
      description: "Terjadi kesalahan pada proses enkoding/dekoding ketika melakukan $function $code",
      type: type,
    );
  }

  static ExceptionRule rule({
    required String module,
    required String layer,
    required String function,
    Object? stackTrace,
  }) => ExceptionRule(
    predicate: (exception) => _acceptableException.any((type) => exception.runtimeType == type),
    transformer:
      (exception) => DecodeFailedException(
        module: module,
        layer: layer,
        function: function,
        stackTrace: stackTrace,
      ),
  );

  static final _acceptableException = [FormatException, TypeError, RangeError];
}
