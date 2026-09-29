import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';

final userNameRiverpod = FutureProvider.autoDispose<String?>((ref) async {
  return await LoginPreferences.userName;
});
