import 'package:exception/exception.dart';

/// Thrown when the caller does not have permission to execute the operation
class FirestorePermissionDeniedException extends FirestoreException {
  FirestorePermissionDeniedException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'The caller does not have permission to execute the specified operation',
          firesoteErrorCode: 'PERMISSION_DENIED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Permission Denied',
      description: message ?? 'You do not have permission to perform this operation',
      type: type,
    );
  }
}
