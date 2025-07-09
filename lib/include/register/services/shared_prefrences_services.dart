// lib/services/local_cache.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const _keyRegistered = 'isRegistered';

  Future<void> setRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRegistered, true);
  }

  Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRegistered) ?? false;
  }
}
