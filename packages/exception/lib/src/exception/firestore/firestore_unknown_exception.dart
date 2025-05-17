import 'package:exception/exception.dart';

/// Thrown for unknown errors or errors from a different error domain
class FirestoreUnknownException extends FirestoreException {
  FirestoreUnknownException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'An unknown error occurred',
          firesoteErrorCode: 'UNKNOWN',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Unknown Error',
      description: message ?? 'An unknown error occurred',
      type: type,
    );
  }
}
