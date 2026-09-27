// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:absensi_dede/absensi/models/login_request.dart';
import 'package:absensi_dede/absensi/models/login_response.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login Models Test', () {
    test(
      'LoginRequest payload serialization matches server expected structure',
      () {
        final request = LoginRequest(
          email: 'budi@example.com',
          password: 'passwords',
        );

        final jsonMap = request.toJson();
        expect(jsonMap['email'], equals('budi@example.com'));
        expect(jsonMap['password'], equals('passwords'));
      },
    );

    test('LoginResponse deserializes success response correctly', () {
      final successJson = jsonDecode('''
      {
          "message": "Login berhasil",
          "data": {
              "token": "14|zzUM9ra1heamxdO6EcQqmWXEb9eQsqE67NuNWPbV15f2e48d",
              "user": {
                  "id": 1,
                  "name": "budianduks",
                  "email": "budi@example.com",
                  "email_verified_at": null,
                  "created_at": "2025-04-10T07:01:59.000000Z",
                  "updated_at": "2025-04-11T01:45:42.000000Z"
              }
          }
      }
      ''') as Map<String, dynamic>;

      final response = LoginResponse.fromJson(successJson);
      expect(response.message, equals('Login berhasil'));
      expect(response.data, isNotNull);
      expect(
        response.data!.token,
        equals('14|zzUM9ra1heamxdO6EcQqmWXEb9eQsqE67NuNWPbV15f2e48d'),
      );
      expect(response.data!.user, isNotNull);
      expect(response.data!.user!.id, equals(1));
      expect(response.data!.user!.name, equals('budianduks'));
      expect(response.data!.user!.email, equals('budi@example.com'));
      expect(response.data!.user!.emailVerifiedAt, isNull);
      expect(response.data!.user!.createdAt, isNotNull);
    });

    test('LoginResponse deserializes failure response correctly', () {
      final failJson = jsonDecode('''
      {
          "message": "Email atau password salah",
          "data": null
      }
      ''') as Map<String, dynamic>;

      final response = LoginResponse.fromJson(failJson);
      expect(response.message, equals('Email atau password salah'));
      expect(response.data, isNull);
    });
  });

  group('LoginPreferences Test', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('LoginPreferences saves and loads login response data', () async {
      final successJson = jsonDecode('''
      {
          "message": "Login berhasil",
          "data": {
              "token": "14|zzUM9ra1heamxdO6EcQqmWXEb9eQsqE67NuNWPbV15f2e48d",
              "user": {
                  "id": 1,
                  "name": "budianduks",
                  "email": "budi@example.com",
                  "email_verified_at": null,
                  "created_at": "2025-04-10T07:01:59.000000Z",
                  "updated_at": "2025-04-11T01:45:42.000000Z"
              }
          }
      }
      ''') as Map<String, dynamic>;

      final response = LoginResponse.fromJson(successJson);

      expect(await LoginPreferences.isLogin, isFalse);

      await LoginPreferences.saveLoginResponse(response);

      expect(await LoginPreferences.isLogin, isTrue);
      expect(
        await LoginPreferences.token,
        equals('14|zzUM9ra1heamxdO6EcQqmWXEb9eQsqE67NuNWPbV15f2e48d'),
      );
      expect(await LoginPreferences.userId, equals(1));
      expect(await LoginPreferences.userName, equals('budianduks'));
      expect(await LoginPreferences.userEmail, equals('budi@example.com'));

      final user = await LoginPreferences.user;
      expect(user, isNotNull);
      expect(user!.name, equals('budianduks'));

      await LoginPreferences.logOut();
      expect(await LoginPreferences.isLogin, isFalse);
      expect(await LoginPreferences.token, isNull);
      expect(await LoginPreferences.userName, isNull);
    });
  });
}
