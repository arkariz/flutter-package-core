import 'package:exception/exception.dart';

/// Thrown when the request does not have valid authentication credentials
class FirestoreUnauthenticatedException extends FirestoreException {
  FirestoreUnauthenticatedException({
    required super.module,
    required super.layer,
    required super.function,
    String? message,
    super.stackTrace,
  }) : super(
          message: message ?? 'Request does not have valid authentication credentials',
          firesoteErrorCode: 'UNAUTHENTICATED',
        );

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Unauthenticated',
      description: message ?? 'You need to be authenticated to perform this action',
      type: type,
    );
  }
}
