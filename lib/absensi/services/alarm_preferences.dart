import 'package:shared_preferences/shared_preferences.dart';

class AlarmPreferences {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _keyAlarmHour = 'alarm_hour';
  static const String _keyAlarmMinute = 'alarm_minute';
  static const String _keyAlarmTime = 'alarm_time';
  static const String _keyAlarmEnabled = 'alarm_enabled';
  static const String _keyAlarmId = 'alarm_id';

  /// Menyimpan konfigurasi waktu alarm ke shared preferences
  static Future<void> saveAlarm({
    required int hour,
    required int minute,
    int id = 1001,
  }) async {
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    await _asyncPref.setInt(_keyAlarmHour, hour);
    await _asyncPref.setInt(_keyAlarmMinute, minute);
    await _asyncPref.setString(_keyAlarmTime, timeStr);
    await _asyncPref.setInt(_keyAlarmId, id);
    await _asyncPref.setBool(_keyAlarmEnabled, true);
  }

  /// Menonaktifkan status alarm
  static Future<void> clearAlarm() async {
    await _asyncPref.setBool(_keyAlarmEnabled, false);
  }

  /// Jam alarm (0-23)
  static Future<int?> get alarmHour async =>
      await _asyncPref.getInt(_keyAlarmHour);

  /// Menit alarm (0-59)
  static Future<int?> get alarmMinute async =>
      await _asyncPref.getInt(_keyAlarmMinute);

  /// Waktu alarm dalam format 24 jam (HH:mm)
  static Future<String?> get alarmTime async =>
      await _asyncPref.getString(_keyAlarmTime);

  /// ID alarm
  static Future<int> get alarmId async =>
      (await _asyncPref.getInt(_keyAlarmId)) ?? 1001;

  /// Status apakah alarm aktif
  static Future<bool> get isAlarmEnabled async =>
      (await _asyncPref.getBool(_keyAlarmEnabled)) ?? false;
}
