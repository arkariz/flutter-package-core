import 'package:exception/exception.dart';

/// Thrown when client specifies an invalid argument
class FirestoreInvalidArgumentException extends FirestoreException {
  FirestoreInvalidArgumentException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Invalid argument specified',
          firesoteErrorCode: 'INVALID_ARGUMENT',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Invalid Argument',
      description: message ?? 'One or more arguments are invalid',
      type: type,
    );
  }
}
