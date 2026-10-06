import 'package:absensi_kopdes/absensi/services/alarm_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlarmPreferences Day & Schedule Logic Tests', () {
    test('Day name and short name format correctly in Indonesian', () {
      expect(AlarmPreferences.getDayName(DateTime.monday), 'Senin');
      expect(AlarmPreferences.getDayName(DateTime.tuesday), 'Selasa');
      expect(AlarmPreferences.getDayName(DateTime.wednesday), 'Rabu');
      expect(AlarmPreferences.getDayName(DateTime.thursday), 'Kamis');
      expect(AlarmPreferences.getDayName(DateTime.friday), 'Jumat');
      expect(AlarmPreferences.getDayName(DateTime.saturday), 'Sabtu');
      expect(AlarmPreferences.getDayName(DateTime.sunday), 'Minggu');

      expect(AlarmPreferences.getDayShortName(DateTime.monday), 'Sen');
      expect(AlarmPreferences.getDayShortName(DateTime.tuesday), 'Sel');
      expect(AlarmPreferences.getDayShortName(DateTime.wednesday), 'Rab');
      expect(AlarmPreferences.getDayShortName(DateTime.thursday), 'Kam');
      expect(AlarmPreferences.getDayShortName(DateTime.friday), 'Jum');
      expect(AlarmPreferences.getDayShortName(DateTime.saturday), 'Sab');
      expect(AlarmPreferences.getDayShortName(DateTime.sunday), 'Min');
    });

    test('formatDaysSummary formats predefined presets and custom days', () {
      expect(
        AlarmPreferences.formatDaysSummary(AlarmPreferences.allDays),
        'Setiap Hari (Senin - Minggu)',
      );
      expect(
        AlarmPreferences.formatDaysSummary(AlarmPreferences.defaultDays),
        'Hari Kerja (Senin - Jumat)',
      );
      expect(
        AlarmPreferences.formatDaysSummary([
          DateTime.saturday,
          DateTime.sunday,
        ]),
        'Akhir Pekan (Sabtu - Minggu)',
      );
      expect(
        AlarmPreferences.formatDaysSummary([
          DateTime.monday,
          DateTime.thursday,
        ]),
        'Senin, Kamis',
      );
      expect(AlarmPreferences.formatDaysSummary([]), 'Tidak ada hari dipilih');
    });

    test('calculateNextAlarmDateTime returns a date strictly in the future or matching candidate', () {
      final now = DateTime.now();
      // Future hour today (or next week if after 23:58)
      final futureTime = now.add(const Duration(minutes: 5));

      final scheduled = AlarmPreferences.calculateNextAlarmDateTime(
        hour: futureTime.hour,
        minute: futureTime.minute,
        days: [now.weekday],
      );

      expect(scheduled.isAfter(now), isTrue);
      expect(scheduled.hour, futureTime.hour);
      expect(scheduled.minute, futureTime.minute);
    });

    test('calculateNextAlarmDateTime finds next day if today time is past', () {
      final now = DateTime.now();
      // An hour clearly in the past for today (e.g. 00:00 when now is afternoon/evening)
      final pastHour = 0;
      final pastMinute = 0;

      final scheduled = AlarmPreferences.calculateNextAlarmDateTime(
        hour: pastHour,
        minute: pastMinute,
        days: [now.weekday],
      );

      // Must be scheduled for next week on the same weekday, strictly in the future
      expect(scheduled.isAfter(now), isTrue);
      expect(scheduled.weekday, now.weekday);
      expect(scheduled.hour, pastHour);
      expect(scheduled.minute, pastMinute);
    });
  });
}
