# Flutter Storage Package Documentation

## 1. OVERVIEW

### Purpose and Primary Functionality
The Flutter Storage package provides a secure and efficient storage solution for Flutter applications using Hive as the underlying storage engine. It offers two main storage mechanisms:

1. **Preference Storage**: A key-value store for application preferences and settings
2. **Database Storage**: A structured storage solution for custom data models

### When to Use
- Use Preference Storage for:
  - Application settings and configurations
  - User preferences
  - Small, frequently accessed data
  - Simple key-value pairs

- Use Database Storage for:
  - Structured data models
  - Complex data relationships
  - Large datasets
  - Type-safe storage operations

### Architectural Context
The storage package integrates with:
- Hive CE for the storage engine
- Get_it for dependency injection
- Secure storage for encryption
- Exception handling for error management

## 2. TECHNICAL SPECIFICATION

### Core Components

#### Preference Storage
```dart
Future<Preference> init({
  required String name,
  required OpenPreference openPreference,
  HiveAesCipher? encryptionCipher,
})
```

#### Database Storage
```dart
Future<Database<T>> init<T>({
  required String name,
  required OpenDatabase<T> openDatabase,
  TypeAdapter<T>? adapter,
  HiveAesCipher? encryptionCipher,
})
```

### Type Definitions
```dart
// Entity interface for database models
abstract class Entity<T> {
  T toModel();
}

// Type adapters for custom models
TypeAdapter<T>
```

### State Management
- Uses Get_it for dependency injection
- Provides asynchronous initialization
- Maintains singleton instances for storage boxes
- Handles encryption keys through dependency injection

### Events
- Initialization events through Future completion
- Error handling through exception handlers
- Secure storage key generation events

### Custom Exception Handling
The `openPreference` and `openDatabase` parameters are designed to be flexible, allowing you to implement custom exception handling. However, it's recommended to use the internal exception package for several reasons:

1. **Consistent Error Handling**: The internal exception package provides standardized error handling across the application
2. **Type Safety**: It offers type-safe exception handling with proper error codes and messages
3. **Layered Exception Handling**: It supports layered exception handling which is crucial for storage operations
4. **Built-in Rules**: The package includes pre-defined exception rules for common storage scenarios

Example using internal exception package:
```dart
// Using internal exception package
await provideStorageModule(
  appPreferenceName: "app_preference",
  keySecureStorage: "key_secure_storage",
  openPreference: ({required call, required function, required module}) => 
    openBox(
      module: module,
      function: function,
      call: call,
    ),
);

// Custom implementation (not recommended unless necessary)
await provideStorageModule(
  appPreferenceName: "app_preference",
  keySecureStorage: "key_secure_storage",
  openPreference: ({required call, required function, required module}) async {
    try {
      return await call();
    } catch (e) {
      // Custom error handling
      throw StorageException(message: e.toString());
    }
  },
);
```

## 3. IMPLEMENTATION EXAMPLES

### Basic Usage
```dart
// Initialize storage module
await provideStorageModule(
  appPreferenceName: "app_preference",
  keySecureStorage: "key_secure_storage",
  openPreference: ({required call, required function, required module}) => 
    openBox(module: module, function: function, call: call),
);

// Get preference instance
final preference = await getPreference();

// Store data
await preference.box.put("key", "value");

// Retrieve data
final value = preference.box.get("key");
```

### Advanced Configuration
```dart
// Custom model with encryption
@HiveType(typeId: 1)
class User extends Entity<Map<String, dynamic>> {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;

  User({required this.id, required this.name});

  @override
  Map<String, dynamic> toModel() => {
    'id': id,
    'name': name,
  };
}

// Initialize database with custom adapter
final database = await Database.init<User>(
  name: "users",
  openDatabase: ({required call, required function, required module}) => 
    openBox(module: module, function: function, call: call),
  adapter: UserAdapter(),
  encryptionCipher: await getHiveAesCipher(),
);
```

### Best Practices
1. Always use encryption for sensitive data
2. Use proper error handling with exception handlers
3. Initialize storage before app startup
4. Use dependency injection for better testability
5. Follow Hive's best practices for data modeling

## 4. TROUBLESHOOTING

### Common Errors
1. **Encryption Initialization**
   - Error: "Encryption key not found"
   - Solution: Ensure secure storage is properly initialized

2. **Adapter Registration**
   - Error: "Adapter not registered"
   - Solution: Register adapter before opening box

3. **Box Access**
   - Error: "Box not open"
   - Solution: Ensure box is initialized before use

### Debugging Strategies
1. Add logging to storage operations
2. Check encryption key generation
3. Verify adapter registrations
4. Monitor storage initialization sequence

### Performance Considerations
1. Use bulk operations for multiple writes
2. Implement proper indexing for queries
3. Consider data compression for large datasets
4. Use appropriate data types for storage

## 5. RELATED COMPONENTS

### Dependencies
- `hive_ce`: Core storage engine
- `get_it`: Dependency injection
- `secure_storage`: Encryption
- `exception`: Error handling

### Common Usage Patterns
1. **State Management**
   - Combine with Get_it for dependency injection
   - Use with Bloc/Provider for state management

2. **Data Flow**
   - Implement repository pattern
   - Use with network layer for data synchronization

3. **Error Handling**
   - Integrate with global error handling
   - Implement retry mechanisms

### Alternatives
1. **SharedPreferences**: For simple key-value storage
2. **SQLite**: For more complex database needs
3. **File Storage**: For large file storage
4. **Firebase**: For cloud storage needs

## 6. CONTRIBUTING

1. Follow the project's coding standards
2. Write tests for new features
3. Update documentation
4. Ensure backward compatibility
5. Submit pull requests with clear descriptions

## 7. LICENSE

This package is licensed under the MIT License. See LICENSE file for details.
