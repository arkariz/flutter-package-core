import 'package:exception/exception.dart';

/// Thrown for internal errors
class FirestoreInternalException extends FirestoreException {
  FirestoreInternalException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Internal system error',
          firesoteErrorCode: 'INTERNAL',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Internal Error',
      description: message ?? 'An internal error occurred',
      type: type,
    );
  }
}
