import 'dart:convert';

import 'package:absensi_kopdes/absensi/models/login/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPreferences {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _keyIsLogin = 'isLogin';
  static const String _keyToken = 'token';
  static const String _keyUserData = 'userData';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';

  static Future<void> setLogin(bool isLogin) async {
    await _asyncPref.setBool(_keyIsLogin, isLogin);
  }

  static Future<bool> get isLogin async {
    return await _asyncPref.getBool(_keyIsLogin) ?? false;
  }

  static Future<void> setToken(String token) async {
    await _asyncPref.setString(_keyToken, token);
  }

  static Future<String?> get token async {
    return await _asyncPref.getString(_keyToken);
  }

  static Future<void> saveUser(User user) async {
    if (user.id != null) {
      await _asyncPref.setInt(_keyUserId, user.id!);
    }
    if (user.name != null) {
      await _asyncPref.setString(_keyUserName, user.name!);
    }
    if (user.email != null) {
      await _asyncPref.setString(_keyUserEmail, user.email!);
    }
    await _asyncPref.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  static Future<User?> get user async {
    final userJson = await _asyncPref.getString(_keyUserData);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<int?> get userId async => await _asyncPref.getInt(_keyUserId);

  static Future<String?> get userName async =>
      await _asyncPref.getString(_keyUserName);

  static Future<String?> get userEmail async =>
      await _asyncPref.getString(_keyUserEmail);

  static Future<void> saveLoginResponse(LoginResponseModel response) async {
    await setLogin(true);
    if (response.data?.token != null) {
      await setToken(response.data!.token!);
    }
    if (response.data?.user != null) {
      await saveUser(response.data!.user!);
    }
  }

  static Future<void> saveLoginData(Data data) async {
    await setLogin(true);
    if (data.token != null) {
      await setToken(data.token!);
    }
    if (data.user != null) {
      await saveUser(data.user!);
    }
  }

  static Future<void> logOut() async {
    await _asyncPref.remove(_keyIsLogin);
    await _asyncPref.remove(_keyToken);
    await _asyncPref.remove(_keyUserData);
    await _asyncPref.remove(_keyUserId);
    await _asyncPref.remove(_keyUserName);
    await _asyncPref.remove(_keyUserEmail);
  }
}
