# Exception Handling Module

A robust, type-safe exception handling system for Flutter applications, providing a structured way to handle errors across different layers of your application.

## 1. Overview

### Purpose and Primary Functionality

The Exception module provides a standardized way to handle and process exceptions in Flutter applications. It offers:

- A hierarchy of custom exception types for different error scenarios
- Structured error information including module, layer, and function context
- Consistent error handling patterns across the application
- Support for various error sources (API, local storage, network, etc.)
- Easy integration with state management solutions

### When to Use

Use this module when you need:
- Consistent error handling across your application
- Detailed error information for debugging and logging
- Type-safe exception handling
- Separation of concerns between error handling and business logic

### Architectural Context

This module sits between the data sources (API, local storage) and the presentation layer, providing a unified way to handle and transform errors before they reach the UI.

```
┌─────────────────┐     ┌─────────────────────┐     ┌────────────────┐
│                 │     │                     │     │                │
│   Data Sources  ├────►│  Exception Module   ├────►│     UI Layer   │
│  (API, Storage) │     │  (This Package)     │     │                │
└─────────────────┘     └─────────────────────┘     └────────────────┘
```

## 2. Technical Specification

### Core Components

#### Base Exception

```dart
abstract class CoreException implements Exception {
  String get module;      // Module where exception occurred
  String get code;        // Unique error code
  String get layer;       // Layer (Repository, UseCase, etc.)
  String get function;    // Function where exception was thrown
  String? get message;    // Error message
  Object? get stackTrace; // Stack trace
  
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type});
  String generatedCode({required String code});
}
```

### Exception Types

#### Core Exceptions
| Exception Class | Description | Typical Use Case |
|----------------|-------------|------------------|
| `CoreException` | Base class for all custom exceptions | Base exception type |
| `GeneralException` | Generic fallback exception | Unhandled errors |
| `DecodeFailedException` | Data parsing errors | JSON decoding failures |
| `NoInternetConnectionException` | Network availability | Offline scenarios |
| `PermissionDeniedException` | Permission issues | Camera, location, etc. |
| `RetryExceededException` | Maximum retry attempts reached | API call retries |
| `UploadInProgressException` | Upload already in progress | File uploads |
| `StreamUploadFailedException` | Streaming upload failed | File uploads |
| `PollingTimeOutException` | Polling operation timed out | Background sync |

#### Storage Exceptions
| Exception Class | Description | Typical Use Case |
|----------------|-------------|------------------|
| `LocalStorageCorruptionException` | Local storage data corruption | Database errors |
| `LocalStorageAlreadyOpenedException` | Storage already open | Database initialization |
| `LocalStorageClosedException` | Storage not initialized | Database access |
| `StorageFullException` | No storage space left | File operations |

#### API Exceptions
| Exception Class | Description | Typical Use Case |
|----------------|-------------|------------------|
| `ApiErrorException` | API call failures | HTTP errors |
| `RequestTimeOutException` | API request timeout | Slow network conditions |
| `RetryExceededException` | Maximum retry attempts reached | API call retries |
| `UndefinedErrorResponseException` | Invalid API response format | API integration |

#### Firestore Exceptions
| Exception Class | Description | Typical Use Case |
|----------------|-------------|------------------|
| `FirestoreException` | Base class for all Firestore exceptions | Base exception type |
| `FirestoreAbortedException` | Operation was aborted | Transaction conflicts |
| `FirestoreAlreadyExistsException` | Document already exists | Duplicate document creation |
| `FirestoreCancelledException` | Operation was cancelled | User cancelled operation |
| `FirestoreDataLossException` | Unrecoverable data loss | Corrupted documents |
| `FirestoreDeadlineExceededException` | Operation timed out | Slow network conditions |
| `FirestoreFailedPreconditionException` | Operation precondition failed | Invalid document state |
| `FirestoreInternalException` | Internal Firestore error | Server-side issues |
| `FirestoreInvalidArgumentException` | Invalid argument provided | Invalid query parameters |
| `FirestoreNotFoundException` | Document not found | Missing documents |
| `FirestoreOutOfRangeException` | Operation out of valid range | Invalid array indices |
| `FirestorePermissionDeniedException` | Permission denied | Insufficient permissions |
| `FirestoreResourceExhaustedException` | Resource limits exceeded | Quota exceeded |
| `FirestoreUnauthenticatedException` | User not authenticated | Authentication required |
| `FirestoreUnavailableException` | Service unavailable | Service downtime |
| `FirestoreUnimplementedException` | Operation not implemented | Unsupported features |
| `FirestoreUnknownException` | Unknown error | Fallback for unhandled errors |

### Handlers

#### ExceptionHandler
Base handler for processing exceptions with custom rules. Provides the foundation for all exception handling.

#### ServiceExceptionHandler
Specialized handler for service/API related exceptions. Handles HTTP errors, timeouts, and network issues.

#### FirestoreExceptionHandler
Handles Firestore specific exceptions. Converts Firestore errors into typed exceptions with detailed information.

#### HiveExceptionHandler
Handles Hive local storage exceptions. Manages local storage specific errors like read/write failures.

### Creating Custom Exception Rules

You can create custom exception handling rules for specific scenarios:

```dart
// Define a custom exception rule
final customRule = ExceptionRule(
  predicate: (e) => e is SocketException || e is HttpException,
  transformer: (e) => CustomNetworkException(
    module: 'NetworkModule',
    layer: 'Repository',
    function: 'fetchData',
    message: 'Network request failed',
    originalException: e,
  ),
);

// Use the rule in your handler
return process(
  module: 'MyModule',
  layer: ExceptionLayerCode.repository,
  function: 'myFunction',
  rules: [customRule, ...defaultRules],
  call: myApiCall,
);
```

## 3. Implementation Examples

### Basic Usage

```dart
try {
  // Your code here
} on CoreException catch (e) {
  // Handle specific exception
  logger.e('Error in ${e.module}.${e.function}: ${e.message}');
  showErrorDialog(e.toInfo());
}
```

### Creating Custom Exceptions

```dart
class CustomException extends CoreException {
  CustomException({
    required String module,
    required String layer,
    required String function,
    String? message,
    Object? stackTrace,
  }) : super(
          module: module,
          layer: layer,
          function: function,
          message: message ?? 'Custom error message',
          stackTrace: stackTrace,
        );

  @override
  String get code => generatedCode(code: 'CUSTOM_ERROR');

  @override
  ExceptionInfo toInfo({String? title, required ExceptionDisplayType type}) {
    return ExceptionInfo(
      title: title ?? 'Custom Error',
      description: message ?? 'An error occurred',
      type: type,
    );
  }
}
```

### Using with Service Calls

#### API Service Example
```dart
Future<User> getUser(String userId) async {
  return processServiceCall(
    module: 'UserRepository',
    function: 'getUser',
    call: () async {
      final response = await _apiClient.get('/users/$userId');
      return User.fromJson(response.data);
    },
  );
}
```

#### Firestore Example
```dart
Future<DocumentSnapshot> getUserDocument(String userId) async {
  return processFirestoreCall(
    module: 'UserRepository',
    function: 'getUserDocument',
    call: () async {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    },
  );
}
```

#### Handling Firestore Exceptions
```dart
try {
  final doc = await getUserDocument('user123');
  // Process document
} on FirestorePermissionDeniedException {
  // Handle permission issues
  showError('You do not have permission to access this document');
} on FirestoreNotFoundException {
  // Handle missing document
  showError('User not found');
} on FirestoreException catch (e) {
  // Handle other Firestore exceptions
  logger.e('Firestore error: ${e.message}');
  showError('An error occurred while accessing the database');
}
```

## 4. Troubleshooting

### Common Issues

1. **Missing Exception Handler**
   - Ensure you have a catch-all handler for `CoreException`
   - Check that all exception types are properly registered

2. **Incorrect Error Messages**
   - Verify error messages are properly localized
   - Check that the correct exception type is being thrown

3. **Stack Trace Issues**
   - Always include the original stack trace when re-throwing exceptions
   - Use `Error.throwWithStackTrace` for proper stack trace preservation

### Debugging Tips

1. Enable verbose logging for exceptions:
   ```dart
   Logger.level = Level.verbose;
   ```

2. Use the `toInfo()` method to get user-friendly error messages:
   ```dart
   final errorInfo = exception.toInfo();
   showDialog(
     title: errorInfo.title,
     content: errorInfo.description,
   );
   ```

## 5. Related Components

### Dependencies
- `dio`: For HTTP client functionality
- `hive`: For local storage
- `cloud_firestore`: For Firestore database
- `logger`: For logging

### Commonly Used With
- State management solutions (Provider, Riverpod, Bloc)
- API clients
- Local storage solutions
- Authentication services

### Alternatives
- `dio`'s built-in error handling
- Direct try-catch blocks with standard Dart exceptions
- Other error handling packages like `error_handler`

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
