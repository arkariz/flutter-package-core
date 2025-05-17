import 'package:exception/exception.dart';

/// Thrown when a Firestore operation was aborted
class FirestoreAbortedException extends FirestoreException {
  FirestoreAbortedException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'The operation was aborted, typically due to a concurrency issue like transaction aborts',
          firesoteErrorCode: 'ABORTED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Operation Aborted',
      description: message ?? 'The operation was aborted due to a concurrency issue',
      type: type,
    );
  }
}
