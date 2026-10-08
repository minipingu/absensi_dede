import 'package:alarm/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPreferences {
  static final SharedPreferencesAsync _asyncPref = SharedPreferencesAsync();

  static const String _keyAlarmHour = 'alarm_hour';
  static const String _keyAlarmMinute = 'alarm_minute';
  static const String _keyAlarmTime = 'alarm_time';
  static const String _keyAlarmEnabled = 'alarm_enabled';
  static const String _keyAlarmId = 'alarm_id';
  static const String _keyAlarmDays = 'alarm_days';

  /// Default hari aktif: Senin sampai Jumat (1 - 5)
  static const List<int> defaultDays = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  /// Seluruh hari: Senin sampai Minggu (1 - 7)
  static const List<int> allDays = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  /// Menyimpan konfigurasi waktu alarm dan hari aktif ke shared preferences
  static Future<void> saveAlarm({
    required int hour,
    required int minute,
    List<int> selectedDays = defaultDays,
    int id = 1001,
  }) async {
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    await _asyncPref.setInt(_keyAlarmHour, hour);
    await _asyncPref.setInt(_keyAlarmMinute, minute);
    await _asyncPref.setString(_keyAlarmTime, timeStr);
    await _asyncPref.setInt(_keyAlarmId, id);
    await _asyncPref.setBool(_keyAlarmEnabled, true);
    await saveAlarmDays(selectedDays);
  }

  /// Menyimpan pilihan hari (1 = Senin .. 7 = Minggu) ke shared preferences
  static Future<void> saveAlarmDays(List<int> days) async {
    final strList = days.map((d) => d.toString()).toList();
    await _asyncPref.setStringList(_keyAlarmDays, strList);
  }

  /// Mendapatkan pilihan hari alarm (1 = Senin .. 7 = Minggu) dari shared preferences
  static Future<List<int>> get alarmDays async {
    final list = await _asyncPref.getStringList(_keyAlarmDays);
    if (list == null || list.isEmpty) {
      return defaultDays;
    }
    final parsed = list.map((s) => int.tryParse(s)).whereType<int>().toList();
    return parsed.isEmpty ? defaultDays : parsed;
  }

  /// Menonaktifkan status alarm
  static Future<void> clearAlarm() async {
    await _asyncPref.setBool(_keyAlarmEnabled, false);
  }

  /// Mengaktifkan status alarm kembali
  static Future<void> enableAlarm() async {
    await _asyncPref.setBool(_keyAlarmEnabled, true);
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

  /// Menghitung DateTime alarm berikutnya berdasarkan jam, menit, dan daftar hari terpilih
  static DateTime calculateNextAlarmDateTime({
    required int hour,
    required int minute,
    required List<int> days,
  }) {
    final now = DateTime.now();
    final effectiveDays = days.isEmpty ? defaultDays : days;

    // Periksa apakah hari ini termasuk hari yang dipilih dan jamnya belum terlewat
    if (effectiveDays.contains(now.weekday)) {
      final todayCandidate = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (todayCandidate.isAfter(now)) {
        return todayCandidate;
      }
    }

    // Cari hari terdekat berikutnya dalam 7 hari ke depan
    for (int offset = 1; offset <= 7; offset++) {
      final candidate = now.add(Duration(days: offset));
      if (effectiveDays.contains(candidate.weekday)) {
        return DateTime(
          candidate.year,
          candidate.month,
          candidate.day,
          hour,
          minute,
        );
      }
    }

    // Fallback jika tidak ditemukan kecocokan
    final fallback = now.add(const Duration(days: 1));
    return DateTime(fallback.year, fallback.month, fallback.day, hour, minute);
  }

  /// Helper untuk menjadwalkan alarm ke Alarm plugin
  static Future<bool> scheduleNextAlarm({
    required int hour,
    required int minute,
    required List<int> days,
    int id = 1001,
  }) async {
    final nextDateTime = calculateNextAlarmDateTime(
      hour: hour,
      minute: minute,
      days: days,
    );

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: nextDateTime,
      assetAudioPath: 'assets/alarm/alarm_perang.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: false,
      androidFullScreenIntent: true,
      androidStopAlarmOnTermination: false,
      volumeSettings: const VolumeSettings.fixed(volume: 0.8),
      notificationSettings: const NotificationSettings(
        title: 'Pengingat Check Out',
        body: 'Waktunya melakukan absensi check out!',
        stopButton: 'Matikan Alarm',
      ),
    );

    return await Alarm.set(alarmSettings: alarmSettings);
  }

  /// Nama lengkap hari dalam Bahasa Indonesia (1 = Senin .. 7 = Minggu)
  static String getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '';
    }
  }

  /// Singkatan nama hari (1 = Senin .. 7 = Minggu)
  static String getDayShortName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Sen';
      case DateTime.tuesday:
        return 'Sel';
      case DateTime.wednesday:
        return 'Rab';
      case DateTime.thursday:
        return 'Kam';
      case DateTime.friday:
        return 'Jum';
      case DateTime.saturday:
        return 'Sab';
      case DateTime.sunday:
        return 'Min';
      default:
        return '';
    }
  }

  /// Ringkasan teks hari terpilih
  static String formatDaysSummary(List<int> days) {
    if (days.isEmpty) return 'Tidak ada hari dipilih';
    final sorted = List<int>.from(days)..sort();
    if (sorted.length == 7) return 'Setiap Hari (Senin - Minggu)';
    if (sorted.length == 5 &&
        sorted[0] == 1 &&
        sorted[1] == 2 &&
        sorted[2] == 3 &&
        sorted[3] == 4 &&
        sorted[4] == 5) {
      return 'Hari Kerja (Senin - Jumat)';
    }
    if (sorted.length == 2 && sorted[0] == 6 && sorted[1] == 7) {
      return 'Akhir Pekan (Sabtu - Minggu)';
    }
    return sorted.map(getDayName).join(', ');
  }
}
