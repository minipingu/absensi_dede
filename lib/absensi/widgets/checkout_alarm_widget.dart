import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../services/alarm_preferences.dart';

class CheckoutAlarmWidget extends StatefulWidget {
  const CheckoutAlarmWidget({super.key});

  @override
  State<CheckoutAlarmWidget> createState() => _CheckoutAlarmWidgetState();
}

class _CheckoutAlarmWidgetState extends State<CheckoutAlarmWidget> {
  static const int _alarmId = 1001;
  String? _alarmTime;
  bool _isAlarmActive = false;
  StreamSubscription? _scheduledSub;

  @override
  void initState() {
    super.initState();
    _loadAlarmState();

    // Listen to changes in scheduled alarms to stay in sync
    _scheduledSub = Alarm.scheduled.listen((alarmSet) {
      final isScheduled = alarmSet.alarms.any((a) => a.id == _alarmId);
      if (mounted && _isAlarmActive != isScheduled) {
        setState(() {
          _isAlarmActive = isScheduled;
        });
      }
    });
  }

  @override
  void dispose() {
    _scheduledSub?.cancel();
    super.dispose();
  }

  Future<void> _loadAlarmState() async {
    final enabled = await AlarmPreferences.isAlarmEnabled;
    final time = await AlarmPreferences.alarmTime;
    final alarms = await Alarm.getAlarms();
    final isActuallyScheduled = alarms.any((a) => a.id == _alarmId);

    if (mounted) {
      setState(() {
        _alarmTime = time;
        _isAlarmActive = enabled && isActuallyScheduled;
      });
    }
  }

  Future<void> _openTimePickerDialog() async {
    FTime selectedTime = FTime.now();

    final result = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        animation: animation,
        builder: (dialogContext, style) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Atur Waktu Pengingat', style: style.titleTextStyle),
              const SizedBox(height: 6),
              Text(
                'Pilih jam check out (format 24 jam) untuk menyetel alarm.',
                style: style.bodyTextStyle,
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  height: 180,
                  child: FTimePicker(
                    control: .managed(
                      initial: .now(),
                      onChange: (time) {
                        selectedTime = time;
                      },
                    ),
                    hour24: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FButton(
                    variant: .secondary,
                    onPress: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  FButton(
                    onPress: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      await _scheduleAlarm(selectedTime);
    }
  }

  Future<void> _scheduleAlarm(FTime time) async {
    final now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Jika waktu yang dipilih hari ini sudah lewat, jadwalkan untuk besok
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: _alarmId,
      dateTime: scheduledDateTime,
      assetAudioPath: 'assets/alarm/alarm_perang.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      volumeSettings: const VolumeSettings.fixed(volume: 0.8),
      notificationSettings: const NotificationSettings(
        title: 'Pengingat Check Out',
        body: 'Waktunya melakukan absensi check out!',
        stopButton: 'Matikan Alarm',
      ),
    );

    final success = await Alarm.set(alarmSettings: alarmSettings);
    if (success) {
      await AlarmPreferences.saveAlarm(
        hour: time.hour,
        minute: time.minute,
        id: _alarmId,
      );

      final formatted24h =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      if (mounted) {
        setState(() {
          _alarmTime = formatted24h;
          _isAlarmActive = true;
        });

        showFToast(
          context: context,
          title: const Text('Alarm Berhasil Diatur'),
          description: Text(
            'Pengingat check out disetel untuk pukul $formatted24h WIB',
          ),
          icon: const Icon(Icons.alarm_on),
        );
      }
    } else {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('Gagal Menyetel Alarm'),
          description: const Text('Terjadi kesalahan saat mengatur alarm.'),
          icon: const Icon(Icons.error_outline),
        );
      }
    }
  }

  Future<void> _cancelAlarm() async {
    await Alarm.stop(_alarmId);
    await AlarmPreferences.clearAlarm();

    if (mounted) {
      setState(() {
        _isAlarmActive = false;
      });

      showFToast(
        context: context,
        title: const Text('Alarm Dibatalkan'),
        description: const Text('Pengingat check out telah dimatikan.'),
        icon: const Icon(Icons.alarm_off),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typography = context.theme.typography;

    return FCard(
      style: .delta(
        decoration: .boxDelta(color: colors.background.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Judul & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      color: _isAlarmActive
                          ? Colors.green
                          : colors.mutedForeground,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pengingat Check Out',
                      style: typography.body.lg.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                FBadge(
                  style: _isAlarmActive
                      ? .delta(
                          decoration: .boxDelta(
                            color: Colors.green.withValues(alpha: 0.15),
                          ),
                        )
                      : .delta(
                          decoration: .boxDelta(
                            color: colors.muted.withValues(alpha: 0.3),
                          ),
                        ),
                  child: Text(
                    _isAlarmActive ? 'Aktif' : 'Nonaktif',
                    style: typography.body.xs.copyWith(
                      color: _isAlarmActive
                          ? Colors.green
                          : colors.mutedForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tampilan waktu format 24 jam jika ada
            if (_alarmTime != null && _isAlarmActive) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colors.muted.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waktu Alarm (Format 24 Jam)',
                          style: typography.body.xs.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_alarmTime WIB',
                          style: typography.display.sm.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    FButton(
                      variant: .secondary,
                      onPress: _cancelAlarm,
                      child: const Text('Matikan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ] else ...[
              Text(
                'Atur pengingat agar tidak lupa melakukan check out setelah jam kerja selesai.',
                style: typography.body.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Tombol Setting Waktu Alarm
            SizedBox(
              width: double.infinity,
              child: FButton(
                variant: _isAlarmActive ? .secondary : .primary,
                onPress: _openTimePickerDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _isAlarmActive ? 'Ubah Waktu Alarm' : 'Atur Waktu Alarm',
                      style: typography.body.md.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
