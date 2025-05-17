import 'package:exception/exception.dart';
import 'package:exception/src/model/exception_rule.dart';
import 'package:hive_ce/hive.dart';

class LocalStorageClosedException extends CoreException {
  LocalStorageClosedException({
    required this.module,
    required this.layer,
    required this.function,
    this.stackTrace,
  });

  @override
  String module;

  @override
  String get code => generatedCode(code: ExceptionCode.localStorageClosed.code);

  @override
  String function;

  @override
  String layer;

  @override
  String? get message => "Local Storage Closed";

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

  /// The rule covered error message below:
  /// "Box has already been closed."
  /// "box has already been closed"
  /// "Cannot get value of a closed box."
  /// "Cannot perform operation on a closed box."
  /// "Cannot read from a closed box."
  static ExceptionRule rule({
    required String module,
    required String layer,
    required String function,
    Object? stackTrace,
  }) => ExceptionRule(
    predicate: (exception) {
      final regex = RegExp(
        r'(box has already been closed|cannot (get|perform|read).+closed box)',
        caseSensitive: false,
      );

      return exception is HiveError && regex.hasMatch(exception.message);
    },
    transformer:
      (exception) => LocalStorageClosedException(
        module: module,
        layer: layer,
        function: function,
      ),
  );
}
