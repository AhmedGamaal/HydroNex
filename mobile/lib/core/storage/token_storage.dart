import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage storage;

  const TokenStorage({this.storage = const FlutterSecureStorage()});

  Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }
}
