import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveEncryptionService {
  HiveEncryptionService._();

  static HiveAesCipher? _cipher;

  /// Returns the shared cipher instance. Must call [init] first.
  static HiveAesCipher get cipher {
    assert(_cipher != null, 'HiveEncryptionService.init() must be called first');
    return _cipher!;
  }

  /// Initialise encryption key (call once in main before any Hive.openBox).
  static Future<void> init() async {
    const secureStorage = FlutterSecureStorage();
    const storageKey = 'hiveEncryptionKey';

    final containsKey = await secureStorage.containsKey(key: storageKey);
    if (!containsKey) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: storageKey,
        value: base64UrlEncode(key),
      );
    }

    final encryptionKeyString = await secureStorage.read(key: storageKey);
    final encryptionKey = base64Url.decode(encryptionKeyString!);
    _cipher = HiveAesCipher(encryptionKey);
  }

  /// Convenience wrapper that opens a box with encryption.
  static Future<Box<T>> openBox<T>(String name) {
    return Hive.openBox<T>(name, encryptionCipher: cipher);
  }
}
