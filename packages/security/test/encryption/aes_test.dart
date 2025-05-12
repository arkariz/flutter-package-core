import 'package:security/security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 32 characters for AES-256 (256 bits = 32 bytes)
  const testKey = 'test-secret-key-1234567890-32chars';
  late Aes aes;

  setUp(() {
    aes = Aes(key: testKey);
  });

  group('AES Encryption/Decryption', () {
    test('should encrypt and decrypt text successfully', () {
      // Arrange
      const plainText = 'Hello, World!';
      
      // Act
      final encrypted = aes.encrypt(plainText);
      final decrypted = aes.decrypt(encrypted);
      
      // Assert
      expect(encrypted, isNotEmpty);
      expect(decrypted, equals(plainText));
    });

    test('should handle empty string', () {
      // Arrange
      const emptyString = '';
      
      // Act
      final encrypted = aes.encrypt(emptyString);
      final decrypted = aes.decrypt(encrypted);
      
      // Assert
      expect(encrypted, equals(''));
      expect(decrypted, equals(emptyString));
    });

    test('should handle special characters', () {
      // Arrange
      const specialChars = '!@#\$%^&*()_+{}|:"<>?~`-=[]\\;\',./';
      
      // Act
      final encrypted = aes.encrypt(specialChars);
      final decrypted = aes.decrypt(encrypted);
      
      // Assert
      expect(decrypted, equals(specialChars));
    });

    test('should handle long text', () {
      // Arrange
      final longText = 'A' * 1000; // 1000 characters
      
      // Act
      final encrypted = aes.encrypt(longText);
      final decrypted = aes.decrypt(encrypted);
      
      // Assert
      expect(decrypted, equals(longText));
    });

    test('should return error message for invalid encrypted input', () {
      // Arrange
      const invalidEncrypted = 'not-a-valid-encrypted-string';
      
      // Act
      final result = aes.decrypt(invalidEncrypted);
      
      // Assert
      expect(result, equals('Failed to decrypt'));
    });

    test('should return empty string for empty encrypted input', () {
      // Act
      final result = aes.decrypt('');
      
      // Assert
      expect(result, equals(''));
    });

    test('should handle different key lengths', () {
      // Test with different key lengths
      final aes128 = Aes(key: '16byte-key-12345');
      final aes192 = Aes(key: '24byte-key-123456789012');
      final aes256 = Aes(key: '32byte-key-1234567890123456789012');
      
      const testText = 'Test encryption with different key lengths';
      
      expect(aes128.encrypt(testText), isNot(equals(aes192.encrypt(testText))));
      expect(aes192.encrypt(testText), isNot(equals(aes256.encrypt(testText))));
      
      expect(aes128.decrypt(aes128.encrypt(testText)), equals(testText));
      expect(aes192.decrypt(aes192.encrypt(testText)), equals(testText));
      expect(aes256.decrypt(aes256.encrypt(testText)), equals(testText));
    });

    test('different keys should produce different encrypted outputs', () {
      // Arrange
      const plainText = 'Hello, World!';
      final aes2 = Aes(key: 'different-secret-key-1234567890-32chars');
      
      // Act
      final encrypted1 = aes.encrypt(plainText);
      final encrypted2 = aes2.encrypt(plainText);
      
      // Assert
      expect(encrypted1, isNot(equals(encrypted2)));
    });
  });
}