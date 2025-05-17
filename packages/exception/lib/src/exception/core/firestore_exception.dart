import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exception/exception.dart';
import 'package:exception/src/model/exception_rule.dart';

/// Base class for all Firestore related exceptions
abstract class FirestoreException extends CoreException {
  FirestoreException({
    required this.module,
    required this.layer,
    required this.function,
    required this.firesoteErrorCode,
    this.message,
    this.stackTrace,
  });

  final String firesoteErrorCode;

  @override
  String module;
  
  @override
  String get code => generatedCode(code: firesoteErrorCode);
  
  @override
  String layer;
  
  @override
  String function;
  
  @override
  String? message;
  
  @override
  Object? stackTrace;

  /// Creates a rule for handling Firestore errors
  static ExceptionRule rule({
    required String module,
    required String layer,
    required String function,
    required bool Function(FirebaseException) predicate,
  }) {
    return ExceptionRule(
      predicate: (exception) => exception is FirebaseException && predicate(exception),
      transformer: (exception) {
        final firebaseException = exception as FirebaseException;
        
        switch (firebaseException.code) {
          case 'aborted':
            return FirestoreAbortedException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'already-exists':
            return FirestoreAlreadyExistsException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'cancelled':
            return FirestoreCancelledException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'data-loss':
            return FirestoreDataLossException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'deadline-exceeded':
            return FirestoreDeadlineExceededException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'failed-precondition':
            return FirestoreFailedPreconditionException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'internal':
            return FirestoreInternalException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'invalid-argument':
            return FirestoreInvalidArgumentException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'not-found':
            return FirestoreNotFoundException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'out-of-range':
            return FirestoreOutOfRangeException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'permission-denied':
            return FirestorePermissionDeniedException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'resource-exhausted':
            return FirestoreResourceExhaustedException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'unauthenticated':
            return FirestoreUnauthenticatedException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'unavailable':
            return FirestoreUnavailableException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          case 'unimplemented':
            return FirestoreUnimplementedException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
          default:
            return FirestoreUnknownException(
              module: module,
              layer: layer,
              function: function,
              message: firebaseException.message,
              stackTrace: firebaseException.stackTrace,
            );
        }
      },
    );
  }
}
