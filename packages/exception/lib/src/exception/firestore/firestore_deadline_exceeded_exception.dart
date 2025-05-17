import 'package:exception/exception.dart';

/// Thrown when a deadline expires before an operation could complete
class FirestoreDeadlineExceededException extends FirestoreException {
  FirestoreDeadlineExceededException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Deadline expired before operation could complete',
          firesoteErrorCode: 'DEADLINE_EXCEEDED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Deadline Exceeded',
      description: message ?? 'The operation timed out',
      type: type,
    );
  }
}
