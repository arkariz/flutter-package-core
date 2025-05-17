import 'dart:core';

import 'package:exception/exception.dart';

/// Base class for custom exception, providing structured error details
abstract class CoreException implements Exception {
  /// Module where the exception occured.
  abstract final String module;

  /// Unique error code for the exception.
  abstract final String code;

  /// Layer (e.g., Repository, UseCase, ViewModel) where the exception originated.
  abstract final String layer;

  /// Function where the exception was thrown
  abstract final String function;

  /// Message from the exception
  abstract final String? message;

  /// StackTrace from the exception
  abstract final Object? stackTrace;

  /// Function where the exception mapped to ExceptionInfo to be used in presentation layer
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type});

  /// Generate a unique error code based on module, layer, function, and predefined error code.
  /// @param code The predefined error code.
  /// @return The generated error code.
  String generatedCode({required String code}) => "$module-$layer-$function-$code";

  @override
  String toString() {
    return "$message: $stackTrace";
  }
}
