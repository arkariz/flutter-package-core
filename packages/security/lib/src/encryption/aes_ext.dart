
import 'package:security/src/encryption/aes.dart';
import 'package:security/src/encryption/aes_key.dart';

extension StringExtension on String {

  String encrypt({String? key}) {
    String aesKey = key ?? AesKey.platform;
    return Aes(key: aesKey).encrypt(this);
  }

  String decrypt({String? key}) {
    String aesKey = key ?? AesKey.platform;
    return Aes(key: aesKey).decrypt(this);
  }
}