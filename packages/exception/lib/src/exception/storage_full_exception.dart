import 'dart:io';

import 'package:exception/exception.dart';
import 'package:exception/src/exception/core_exception.dart';
import 'package:exception/src/model/exception_rule.dart';

class StorageFullException extends CoreException {
  StorageFullException({
    required this.module,
    required this.layer,
    required this.function,
    this.stackTrace,
  });

  @override
  String module;

  @override
  String get code => generatedCode(code: ExceptionCode.storageFull.code);

  @override
  String function;

  @override
  String layer;

  @override
  String? get message => "Storage Full";

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
    predicate:
        (exception) =>
            exception is FileSystemException &&
            exception.osError?.message.contains("No space left") == true,
    transformer:
        (exception) => StorageFullException(
          module: module,
          layer: layer,
          function: function,
        ),
  );
}
