import 'package:exception/exception.dart';

/// Thrown when unrecoverable data loss or corruption is encountered
class FirestoreDataLossException extends FirestoreException {
  FirestoreDataLossException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Unrecoverable data loss or corruption',
          firesoteErrorCode: 'DATA_LOSS',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Data Loss',
      description: message ?? 'Unrecoverable data loss or corruption occurred',
      type: type,
    );
  }
}
