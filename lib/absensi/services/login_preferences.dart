import 'dart:convert';

import 'package:absensi_dede/absensi/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPreferences {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _keyIsLogin = 'isLogin';
  static const String _keyToken = 'token';
  static const String _keyUserData = 'userData';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';

  /// Menyimpan status login
  static Future<void> setLogin(bool isLogin) async {
    await _asyncPref.setBool(_keyIsLogin, isLogin);
  }

  /// Mengecek apakah user sudah login
  static Future<bool> get isLogin async {
    return await _asyncPref.getBool(_keyIsLogin) ?? false;
  }

  /// Menyimpan token autentikasi
  static Future<void> setToken(String token) async {
    await _asyncPref.setString(_keyToken, token);
  }

  /// Mendapatkan token autentikasi
  static Future<String?> get token async {
    return await _asyncPref.getString(_keyToken);
  }

  /// Menyimpan data user
  static Future<void> saveUser(LoginUser user) async {
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

  /// Mendapatkan data user lengkap
  static Future<LoginUser?> get user async {
    final userJson = await _asyncPref.getString(_keyUserData);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return LoginUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Mendapatkan ID user
  static Future<int?> get userId async => await _asyncPref.getInt(_keyUserId);

  /// Mendapatkan Nama user
  static Future<String?> get userName async =>
      await _asyncPref.getString(_keyUserName);

  /// Mendapatkan Email user
  static Future<String?> get userEmail async =>
      await _asyncPref.getString(_keyUserEmail);

  /// Menyimpan seluruh data setelah login berhasil
  static Future<void> saveLoginResponse(LoginResponse response) async {
    await setLogin(true);
    if (response.data?.token != null) {
      await setToken(response.data!.token!);
    }
    if (response.data?.user != null) {
      await saveUser(response.data!.user!);
    }
  }

  /// Menyimpan data dari LoginData
  static Future<void> saveLoginData(LoginData data) async {
    await setLogin(true);
    if (data.token != null) {
      await setToken(data.token!);
    }
    if (data.user != null) {
      await saveUser(data.user!);
    }
  }

  /// Logout dan hapus semua data session login
  static Future<void> logOut() async {
    await _asyncPref.remove(_keyIsLogin);
    await _asyncPref.remove(_keyToken);
    await _asyncPref.remove(_keyUserData);
    await _asyncPref.remove(_keyUserId);
    await _asyncPref.remove(_keyUserName);
    await _asyncPref.remove(_keyUserEmail);
  }
}
