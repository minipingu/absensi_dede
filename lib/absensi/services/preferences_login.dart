import 'package:shared_preferences/shared_preferences.dart';

class PreferencesLogin {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _loginKey = 'isLogin';

  static Future<void> setLogin(bool isLogin) async {
    await _asyncPref.setBool(_loginKey, isLogin);
  }

  static Future<bool> get isLogin async {
    return await _asyncPref.getBool(_loginKey) ?? false;
  }

  static Future<void> logOut() async {
    await _asyncPref.remove(_loginKey);
  }
}
