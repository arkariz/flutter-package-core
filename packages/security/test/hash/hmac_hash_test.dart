import 'package:security/security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testKey = 'test-secret-key';
  late HmacHash hmacHash;

  setUp(() {
    hmacHash = HmacHash(key: testKey);
  });

  group('HmacHash', () {
    test('should compute HMAC-SHA256 hash correctly', () {
      // Arrange
      const plainText = 'Hello, World!';
      
      // Act
      final result = hmacHash.compute(plainText: plainText, hashType: sha256);
      
      // Assert
      expect(result, isNotEmpty);
      // Expected value from actual test run
      expect(result, equals('64cc4644ffe2f206e807486fc2cc29de6d9f6f3e86f6c06bdab72f02e6e02c78'));
    });

    test('should compute different hashes for different hash algorithms', () {
      // Arrange
      const plainText = 'test message';
      
      // Act
      final sha1Result = hmacHash.compute(plainText: plainText, hashType: sha1);
      final sha256Result = hmacHash.compute(plainText: plainText, hashType: sha256);
      final sha512Result = hmacHash.compute(plainText: plainText, hashType: sha512);
      
      // Assert
      expect(sha1Result, isNot(equals(sha256Result)));
      expect(sha256Result, isNot(equals(sha512Result)));
      expect(sha1Result, isNot(equals(sha512Result)));
      
      // Verify lengths (hex representation)
      expect(sha1Result.length, equals(40));    // SHA-1: 160 bits = 40 hex chars
      expect(sha256Result.length, equals(64));  // SHA-256: 256 bits = 64 hex chars
      expect(sha512Result.length, equals(128)); // SHA-512: 512 bits = 128 hex chars
    });

    test('should handle empty string input', () {
      // Act
      final result = hmacHash.compute(plainText: '');
      
      // Assert
      expect(result, isNotEmpty);
      expect(result.length, equals(64)); // SHA-256 hash length in hex
    });

    test('should handle special characters in input', () {
      // Arrange
      const specialChars = '!@#\$%^&*()_+{}|:"<>?~`-=[]\\;\',./';
      
      // Act
      final result = hmacHash.compute(plainText: specialChars);
      
      // Assert
      expect(result, isNotEmpty);
      expect(result.length, equals(64)); // SHA-256 hash length in hex
    });

    test('should return different hashes for different keys', () {
      // Arrange
      const plainText = 'same message';
      final hmacHash2 = HmacHash(key: 'different-secret-key');
      
      // Act
      final result1 = hmacHash.compute(plainText: plainText);
      final result2 = hmacHash2.compute(plainText: plainText);
      
      // Assert
      expect(result1, isNot(equals(result2)));
    });
  });
}
