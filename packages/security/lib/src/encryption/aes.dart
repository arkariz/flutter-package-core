import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';

class Aes {
  final String key;
  static const int blockSize = 16;
  static const int ivLength = 16;

  Aes({required this.key}) {
    if (key.isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }
  }

  String encrypt(String plainText) {
    try {
      if (plainText.isEmpty) {
        return "";
      }

      // Generate a random IV
      final iv = Uint8List.fromList(
        List.generate(ivLength, (_) => Random.secure().nextInt(256)),
      );

      // Initialize the cipher
      final crypt = AesCrypt();
      final keyBytes = _processKey(key);
      crypt.aesSetKeys(keyBytes, iv);
      crypt.aesSetMode(AesMode.cbc);

      // Convert text to bytes and add PKCS#7 padding
      final textBytes = utf8.encode(plainText);
      final paddedText = _addPkcs7Padding(Uint8List.fromList(textBytes), blockSize);

      // Encrypt
      final encryptedBytes = crypt.aesEncrypt(paddedText);

      // Combine IV and encrypted data
      final result = Uint8List(iv.length + encryptedBytes.length)
        ..setAll(0, iv)
        ..setAll(iv.length, encryptedBytes);

      return base64.encode(result);
    } catch (e) {
      return "Failed to encrypt";
    }
  }

  String decrypt(String encryptedText) {
    try {
      if (encryptedText.isEmpty) {
        return "";
      }

      // Decode base64
      final encryptedData = base64.decode(encryptedText);
      if (encryptedData.length < ivLength) {
        return 'Failed to decrypt';
      }

      // Extract IV and encrypted bytes
      final iv = Uint8List.sublistView(encryptedData, 0, ivLength);
      final encryptedBytes = Uint8List.sublistView(encryptedData, ivLength);

      // Initialize the cipher
      final crypt = AesCrypt();
      final keyBytes = _processKey(key);
      crypt.aesSetKeys(keyBytes, iv);
      crypt.aesSetMode(AesMode.cbc);

      // Decrypt
      final paddedResult = crypt.aesDecrypt(encryptedBytes);
      
      // Remove PKCS#7 padding
      final result = _removePkcs7Padding(paddedResult);
      
      return utf8.decode(result);
    } catch (e) {
      return 'Failed to decrypt';
    }
  }

  Uint8List _processKey(String key) {
    // Convert key to bytes
    var keyBytes = utf8.encode(key);
    
    // For AES-256, we need a 32-byte key
    if (keyBytes.length < 32) {
      // Pad with zeros if key is too short
      keyBytes = Uint8List(32)..setRange(0, keyBytes.length, keyBytes);
    } else if (keyBytes.length > 32) {
      // Truncate if key is too long
      keyBytes = Uint8List.sublistView(Uint8List.fromList(keyBytes), 0, 32);
    }
    
    return Uint8List.fromList(keyBytes);
  }

  Uint8List _addPkcs7Padding(Uint8List data, int blockSize) {
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setAll(0, data);
    for (var i = data.length; i < padded.length; i++) {
      padded[i] = padLength;
    }
    return padded;
  }

  Uint8List _removePkcs7Padding(Uint8List data) {
    if (data.isEmpty) return Uint8List(0);
    
    final padLength = data[data.length - 1];
    if (padLength > data.length || padLength > blockSize || padLength <= 0) {
      // Invalid padding, return as is
      return data;
    }
    
    // Verify padding
    for (var i = 1; i <= padLength; i++) {
      if (data[data.length - i] != padLength) {
        // Invalid padding, return as is
        return data;
      }
    }
    
    return Uint8List.sublistView(data, 0, data.length - padLength);
  }
}