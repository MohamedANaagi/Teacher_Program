// services/shared_prefs_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static Future<bool> get isRegistered async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isRegistered') ?? false;
  }

  static Future<void> setRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
  }
}
