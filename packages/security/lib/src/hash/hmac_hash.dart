import 'dart:convert';
import 'package:crypto/crypto.dart';

class HmacHash {
  final String key;

  HmacHash({required this.key});

  String compute({required String plainText, Hash hashType = sha256}) {
    try {
      var keyByte = utf8.encode(key);
      var valueBytes = utf8.encode(plainText);

      final hMac = Hmac(hashType, keyByte);
      final digest = hMac.convert(valueBytes);
      return digest.toString();
    } catch (e) {
      return e.toString();
    }
  }

}