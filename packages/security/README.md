<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Security Package

A comprehensive security package providing robust encryption and hashing capabilities for Flutter applications.

## Overview

### Purpose
The Security package offers essential security features including:
- AES encryption with CBC mode
- HMAC hashing with various algorithms
- Secure key management
- PKCS#7 padding for block encryption

### When to Use
Use this package when you need:
- Secure data encryption/decryption
- Data integrity verification
- Secure key storage and management
- Protection of sensitive information

### Architecture
This package integrates with Flutter's crypto package and provides a higher-level abstraction for common security operations. It's designed to be used alongside other security-related packages like secure storage and authentication.

## Technical Specification

### AES Encryption

```dart
class Aes {
  final String key;
  static const int blockSize = 16;
  static const int ivLength = 16;

  Aes({required this.key});

  String encrypt(String plainText);
  String decrypt(String encryptedText);
}
```

#### Parameters
- `key`: Encryption key (32 bytes for AES-256)
- `plainText`: Text to encrypt/decrypt

#### Return Values
- Encrypted/decrypted text in base64 format
- Error message if operation fails

### HMAC Hashing

```dart
class HmacHash {
  final String key;

  HmacHash({required this.key});

  String compute({
    required String plainText,
    Hash hashType = sha256
  });
}
```

#### Parameters
- `key`: HMAC key
- `plainText`: Text to hash
- `hashType`: Hash algorithm (default: sha256)

#### Return Values
- Hex-encoded hash string
- Error message if operation fails

## Setup

### Dependency Injection

The Security package uses a modular approach for dependency injection through the `security_module`. This allows for better organization and separation of concerns.

```dart
import 'package:security/security.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize security module with platform-specific key
  securityModule(
    aesKeyPlatform: "your-platform-specific-key",
  );
  
  // Wait for all services to be ready
  await GetIt.I.allReady();
  
  runApp(MyApp());
}

// Usage in your app
final aesKey = AesKey.platform;
final aes = Aes(key: aesKey);
```

### Implementation Examples

### Basic Usage

```dart
// Get platform-specific key
final aesKey = AesKey.platform;
final databaseKey = AesKey.database;


// Using string extensions
final encrypted = "Sensitive data".encrypt();
final decrypted = encrypted.decrypt();

// Using string extensions with specific key
final encrypted = "Sensitive data".encrypt(key: databaseKey);
final decrypted = encrypted.decrypt(key: databaseKey);

// Or using direct AES class
final aes = Aes(key: aesKey);
final encrypted = aes.encrypt("Sensitive data");
final decrypted = aes.decrypt(encrypted);

// HMAC Hashing Example
final hmac = HmacHash(key: aesKey);
final hash = hmac.compute(plainText: "Data to verify");
```

### Advanced Usage

```dart
// Using different hash algorithms
final hmac = HmacHash(key: aesKey);
final sha1Hash = hmac.compute(plainText: "data", hashType: sha1);
final sha256Hash = hmac.compute(plainText: "data"); // Default is sha256
final sha512Hash = hmac.compute(plainText: "data", hashType: sha512);

// Handling different key lengths
final aes128 = Aes(key: "16byte-key-12345");    // 128-bit key
final aes192 = Aes(key: "24byte-key-123456789012"); // 192-bit key
final aes256 = Aes(key: "32byte-key-1234567890123456789012"); // 256-bit key

// Encrypting special characters
final specialChars = "!@#\$%^&*()_+{}|:"<>?~`-=[]\\;\',./";
final encrypted = specialChars.encrypt();
```

### Best Practices

1. **Key Management**
   - Store keys securely using Flutter's secure storage
   - Never hardcode keys in production code

2. **Encryption**
   - Always use 32-byte keys for AES-256
   - Handle special characters properly
   - Test with different key lengths
   - Verify encryption/decryption round-trips

3. **Hashing**
   - Use SHA-256 as default for HMAC
   - Consider SHA-512 for higher security requirements
   - Verify hash lengths (40 chars for SHA-1, 64 for SHA-256, 128 for SHA-512)
   - Use different keys for different purposes

4. **Error Handling**
   - Handle invalid encrypted inputs gracefully
   - Verify empty string cases
   - Implement proper error logging

### Working with Multiple Keys

To use multiple encryption keys in your application, follow these steps:

1. Add a new qualifier to `AesQualifier`:
```dart
enum AesQualifier {
  platform,
  database,  // For database encryption
  network,   // For network communication
  storage    // For local storage
}
```

2. Register the additional keys in `securityModule`:
```dart
void securityModule({
  required String aesKeyPlatform
}) {
  GetIt.I.registerLazySingleton(
    () => aesKeyPlatform, instanceName: AesQualifier.platform.name
  );

  // Register additional keys
  GetIt.I.registerLazySingleton(
    () => "database-encryption-key",
    instanceName: AesQualifier.database.name
  );
  GetIt.I.registerLazySingleton(
    () => "network-communication-key",
    instanceName: AesQualifier.network.name
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  securityModule(
    aesKeyPlatform: "platform-specific-key",
  );
  
  runApp(MyApp());
}
```

3. Add static properties to `AesKey`:
```dart
class AesKey {
  static String platform = GetIt.I.get<String>(instanceName: AesQualifier.platform.name);

  // Add static properties for additional keys
  static String database = GetIt.I.get<String>(instanceName: AesQualifier.database.name);
  static String network = GetIt.I.get<String>(instanceName: AesQualifier.network.name);
}
```

4. Use the keys in your application:
```dart
// Get specific key
final databaseKey = AesKey.database;
final networkKey = AesKey.network;

// Use in encryption
final databaseAes = Aes(key: databaseKey);
final networkAes = Aes(key: networkKey);

// Or using string extensions with specific keys
final encrypted = "sensitive data".encrypt(key: databaseKey);
```

### Common Pitfalls

1. **Key Length Issues**
   - AES-128: 16 bytes
   - AES-192: 24 bytes
   - AES-256: 32 bytes
   - Keys are automatically padded/truncated to fit the required length

2. **Performance Considerations**
   - Use async operations for large data
   - Cache frequently used keys
   - Consider hardware acceleration where available

3. **Security Considerations**
   - Never reuse IVs for encryption
   - Use secure random number generation
   - Implement proper key rotation policies
   - Store keys securely using platform-specific storage
   - Use different keys for different purposes to limit damage if one key is compromised

### Advanced Configuration

```dart
// Custom AES Key Processing
final customAes = Aes(key: "short-key");
final processedKey = customAes._processKey("short-key"); // Automatically padded to 32 bytes

// Different Hash Algorithms
final hmac = HmacHash(key: "key");
final sha1Hash = hmac.compute(plainText: "data", hashType: sha1);
final sha512Hash = hmac.compute(plainText: "data", hashType: sha512);
```

### Best Practices
1. Always use strong, unique keys
2. Store keys securely using Flutter's secure storage
3. Use appropriate key lengths (32 bytes for AES-256)
4. Implement proper error handling

## Troubleshooting

### Common Errors
1. **Key Length Issues**
   - Solution: Ensure keys are 32 bytes for AES-256
   - Use `_processKey` method to handle key length automatically

2. **Encryption/Decryption Failures**
   - Solution: Verify:
     - Correct key is being used
     - Data format is correct
     - Base64 encoding/decoding is handled properly

3. **Performance Considerations**
   - Use async operations for large data
   - Cache frequently used keys
   - Consider hardware acceleration where available

## Related Components

### Dependencies
- `crypto`: Core cryptographic operations
- `aes_crypt_null_safe`: AES encryption implementation
- `dart:typed_data`: For byte operations

### Common Usage Scenarios
1. Secure Preferences Storage
2. Network Communication Security
3. Secure Data Transfer
4. Authentication Token Management

### Alternatives
- `flutter_secure_storage`: For storing keys
- `pointycastle`: For more cryptographic algorithms
- `encrypt`: For alternative encryption implementations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run tests
4. Submit a pull request

## License

This package is licensed under the MIT License.
