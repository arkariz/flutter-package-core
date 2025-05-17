# Firestore Package

A clean, type-safe wrapper around Cloud Firestore for Flutter applications, providing a more intuitive and maintainable API for Firestore operations.

## Features

- **Type-safe API**: Strongly typed models and queries
- **Simplified CRUD Operations**: Easy-to-use methods for common operations
- **Real-time Updates**: Built-in support for real-time document and collection listeners
- **Batch Writes**: Perform multiple write operations as a single atomic unit
- **Transactions**: Support for atomic transactions with retry logic
- **Query Builder**: Fluent interface for building complex queries
- **Pagination**: Built-in support for paginated queries
- **Maintainable Query Logic**: Shared query-building logic via a private helper for easier maintenance and extension
- **Dependency Injection**: Seamless integration with GetIt
- **Comprehensive Error Handling**: Built-in error handling and logging
- **Modular Design**: Easy to test and extend

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  firestore:
    path: ../../packages/firestore
  cloud_firestore: ^4.15.9
  firebase_core: ^2.27.1
  get_it: ^7.6.7
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase project with Firestore enabled
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) configured

### Installation

1. Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  firestore:
    path: ../../packages/firestore  # or pub.dev reference when published
  cloud_firestore: ^4.15.9
  firebase_core: ^2.27.1
  get_it: ^7.6.7
```

2. Run `flutter pub get`

### Initialization

1. **Initialize Firebase** in your `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Configure Firestore module
  FirestoreModule.configure();
  
  runApp(MyApp());
}
```

## Basic Usage

### Accessing FirestoreService

```dart
// Get an instance of FirestoreService
final firestore = FirestoreModule.firestoreService();

// Or get the raw FirebaseFirestore instance
final firebaseFirestore = FirestoreModule.firebaseFirestore();
```

### Dependency Injection (Recommended)

For better testability and dependency management, it's recommended to use dependency injection:

```dart
// In your dependency injection setup (e.g., di.dart)
import 'package:get_it/get_it.dart';
import 'package:firestore/firestore.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Configure Firestore module
  FirestoreModule.configure();
  
  // Register other dependencies
  // getIt.registerSingleton<YourRepository>(YourRepository());
}

// In your widgets or services
class UserService {
  final FirestoreService _firestore;
  
  UserService() : _firestore = FirestoreModule.firestoreService();
  
  // Your methods here
}
```
```

## Table of Contents

- [Design & Maintainability](#design--maintainability)
- [API Reference](#api-reference)
  - [Document Operations](#document-operations)
    - [Create Document](#create-document)
    - [Read Document](#read-document)
    - [Update Document](#update-document)
    - [Delete Document](#delete-document)
  - [Query Operations](#query-operations)
    - [Query Collection](#query-collection)
    - [Paginated Query](#paginated-query)
  - [Real-time Updates](#real-time-updates)
    - [Watch Document](#watch-document)
    - [Watch Collection](#watch-collection)
  - [Batch Operations](#batch-operations)
  - [Transactions](#transactions)

## Design & Maintainability

### Centralized Query Logic

To improve maintainability and reduce code duplication, the `FirestoreService` uses a private helper method (`_buildQuery`) to construct Firestore queries. This method applies all `where`, `orderBy`, and pagination options in one place, ensuring that:

- The `query`, `watchCollection`, and `queryPaginated` methods always use consistent logic.
- Future changes to query-building only need to be made in one location.
- The codebase is easier to maintain and extend for advanced use cases.

This design pattern helps keep the package robust and developer-friendly as your app grows.

## API Reference

### Document Operations

#### Create Document

Create a new document in the specified collection.

```dart
// Create a new document with auto-generated ID
final docId = await _firestore.create(
  collection: 'users',
  data: {
    'name': 'John Doe',
    'email': 'john@example.com',
    'createdAt': FieldValue.serverTimestamp(),
  },
);

// Create a document with specific ID
await _firestore.create(
  collection: 'users',
  id: 'custom-id-123',
  data: {'name': 'Jane Doe'},
);

// Merge with existing document
await _firestore.create(
  collection: 'users',
  id: 'existing-id',
  data: {'age': 30},
  options: WriteOptions(merge: true),
);
```

#### Read Document

Read a single document from Firestore.

```dart
// Read a document
final userData = await _firestore.read(
  path: 'users/user123',
);

// With server timestamp behavior
final userData = await _firestore.read(
  path: 'users/user123',
  serverTimestampBehavior: ServerTimestampBehavior.estimate,
);
```

#### Update Document

Update fields in a document.

```dart
// Update specific fields
await _firestore.update(
  path: 'users/user123',
  data: {
    'name': 'Updated Name',
    'updatedAt': FieldValue.serverTimestamp(),
  },
);

// Update nested fields using dot notation
await _firestore.update(
  path: 'users/user123',
  data: {
    'profile.name': 'New Name',
    'profile.lastUpdated': FieldValue.serverTimestamp(),
  },
);
```

#### Delete Document

Delete a document from Firestore.

```dart
await _firestore.delete(
  path: 'users/user123',
);
```

### Query Operations

#### Query Collection

Query documents in a collection with filtering, ordering, and limiting.

```dart
// Simple query
final activeUsers = await _firestore.query(
  collection: 'users',
  options: QueryOptions(
    whereConditions: [
      WhereCondition(
        field: 'status',
        operator: WhereOperator.isEqualTo,
        value: 'active',
      ),
      WhereCondition(
        field: 'age',
        operator: WhereOperator.greaterThan,
        value: 18,
      ),
    ],
    orderBy: [
      OrderByCondition(field: 'name'),
      OrderByCondition(field: 'createdAt', descending: true),
    ],
    limit: 10,
  ),
);

// With custom model transformation
final users = await _firestore.query<User>(
  collection: 'users',
  transformer: (snapshot) => User.fromJson(snapshot.data()!..['id'] = snapshot.id),
);
```

#### Paginated Query

Fetch paginated results from a collection.

```dart
final result = await _firestore.queryPaginated(
  collection: 'users',
  pageSize: 10,
  nextPageToken: lastVisibleDoc, // From previous query
  options: QueryOptions(
    orderBy: [OrderByCondition(field: 'name')],
  ),
);

// Use results
final users = result.items;
final hasMore = result.hasMore;
final nextPageToken = result.lastDocument;
```

### Real-time Updates

#### Watch Document

Listen to real-time updates for a single document.

```dart
final userStream = _firestore.watchDocument<User>(
  path: 'users/user123',
  transformer: (snapshot) => User.fromJson(snapshot.data()!..['id'] = snapshot.id),
);

// Use in StreamBuilder
StreamBuilder<User?>(
  stream: userStream,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return Text('User: ${snapshot.data?.name}');
  },
);
```

#### Watch Collection

Listen to real-time updates for a collection query.

```dart
final usersStream = _firestore.watchCollection<User>(
  collection: 'users',
  options: QueryOptions(
    whereConditions: [
      WhereCondition(
        field: 'status',
        operator: WhereOperator.isEqualTo,
        value: 'active',
      ),
    ],
  ),
  transformer: (snapshot) => User.fromJson(snapshot.data()..['id'] = snapshot.id),
);
```

### Batch Operations

Perform multiple write operations as a single atomic unit.

```dart
final operations = [
  WriteOperation.create(
    path: 'users/user1',
    data: {'name': 'User 1'},
  ),
  WriteOperation.update(
    path: 'users/user2',
    data: {'status': 'inactive'},
  ),
  WriteOperation.delete(
    path: 'users/oldUser',
  ),
];

await _firestore.batchWrite(
  operations: operations,
  options: BatchOptions(
    maxBatchSize: 500, // Firestore limit
    isAtomic: true,    // All operations succeed or fail together
  ),
  onProgress: (completed, total) {
    print('Progress: $completed/$total');
  },
);
```

### Transactions

Run a transaction with automatic retry logic.

```dart
try {
  final result = await _firestore.runTransaction(
    (transaction) async {
      // Read a document
      final doc = await transaction.get(_firestore.doc('users/user123'));
      final data = doc.data()!;
      
      // Update the document
      transaction.update(
        _firestore.doc('users/user123'),
        {'counter': (data['counter'] ?? 0) + 1},
      );
      
      return data['counter'] + 1;
    },
    maxAttempts: 3,     // Optional: max retry attempts (default: 5)
    timeout: Duration(seconds: 5), // Optional: transaction timeout
  );
  
  print('New counter value: $result');
} catch (e) {
  print('Transaction failed: $e');
}
```

## Advanced Usage

### Configuration Options

```dart
// Configure with custom Firestore settings
FirestoreModule.configure(
  firestore: FirebaseFirestore.instance, // Custom instance
);
```

### Error Handling

All Firestore operations can throw `FirebaseException`. Always handle errors appropriately:

```dart
try {
  final user = await firestore.read(path: 'users/user123');
} on FirebaseException catch (e) {
  print('Firestore error: ${e.code} - ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### Testing

For testing, you can provide a mock Firestore instance:

```dart
// In your test file
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  
  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    FirestoreModule.configure(firestore: mockFirestore);
  });
  
  test('test firestore operations', () {
    // Your test code
  });
}
```

## Best Practices

1. **Type Safety**
   - Always specify generic types for better type safety
   - Use model classes with `fromJson`/`toJson` for data conversion
   - Create custom model classes for your documents

2. **Error Handling**
   - Implement proper error boundaries
   - Handle offline scenarios gracefully
   - Use retry mechanisms for transient failures

3. **Performance**
   - Use pagination for large collections
   - Limit the number of documents returned in queries
   - Use field masks to fetch only required fields
   - Implement proper indexing for query performance

4. **Security**
   - Implement proper security rules in Firestore
   - Validate and sanitize all user inputs
   - Use Firebase Authentication for access control

5. **State Management**
   - Use a state management solution (like Riverpod or Bloc)
   - Cache data when appropriate
   - Handle real-time updates efficiently

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
