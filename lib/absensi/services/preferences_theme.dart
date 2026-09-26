import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _darkModeKey = 'isDark';

  static Future<void> setTheme(bool isLogin) async {
    await _asyncPref.setBool(_darkModeKey, isLogin);
  }

  static Future<bool> get isDark async {
    return await _asyncPref.getBool(_darkModeKey) ?? false;
  }
}
