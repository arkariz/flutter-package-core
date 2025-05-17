import 'package:exception/exception.dart';

/// Thrown when a Firestore operation was cancelled
class FirestoreCancelledException extends FirestoreException {
  FirestoreCancelledException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'The operation was cancelled',
          firesoteErrorCode: 'CANCELLED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Operation Cancelled',
      description: message ?? 'The operation was cancelled',
      type: type,
    );
  }
}
