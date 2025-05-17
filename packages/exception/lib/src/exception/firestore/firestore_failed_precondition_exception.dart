import 'package:exception/exception.dart';

/// Thrown when the system is not in a state required for the operation's execution
class FirestoreFailedPreconditionException extends FirestoreException {
  FirestoreFailedPreconditionException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Operation failed because the system is not in a required state',
          firesoteErrorCode: 'FAILED_PRECONDITION',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Precondition Failed',
      description: message ?? 'The system is not in a state required for the operation',
      type: type,
    );
  }
}
