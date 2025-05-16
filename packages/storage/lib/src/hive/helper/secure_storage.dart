import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final String key;

  SecureStorage({required this.key});

  Future<HiveAesCipher> generateKey() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? encryptedKey = await secureStorage.read(key: key);

    late List<int> encryptionKey;

    if (encryptedKey == null) {
      // Generate new secure key
      encryptionKey = Hive.generateSecureKey();
      // Save the encoded key securely
      await secureStorage.write(key: key, value: base64UrlEncode(encryptionKey));
    } else {
      // Decode the stored key
      encryptionKey = base64Url.decode(encryptedKey);
    }

    return HiveAesCipher(encryptionKey);
  }
}