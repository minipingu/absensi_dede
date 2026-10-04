import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/alarm_preferences.dart';
import '../services/app_permission_service.dart';

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
    final now = DateTime.now();
    FTime selectedTime = FTime(now.hour, now.minute);
    bool isInvalid = false;

    final result = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        animation: animation,
        builder: (dialogContext, style) => StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final deviceNow = DateTime.now();
            final isBeforeDeviceTime =
                selectedTime.hour < deviceNow.hour ||
                (selectedTime.hour == deviceNow.hour &&
                    selectedTime.minute < deviceNow.minute);

            final formattedNow =
                '${deviceNow.hour.toString().padLeft(2, '0')}:${deviceNow.minute.toString().padLeft(2, '0')}';

            return Padding(
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
                        control: .lifted(
                          time: selectedTime,
                          onChange: (time) {
                            final current = DateTime.now();
                            final isPast =
                                time.hour < current.hour ||
                                (time.hour == current.hour &&
                                    time.minute < current.minute);
                            setDialogState(() {
                              if (isPast) {
                                selectedTime = FTime(
                                  current.hour,
                                  current.minute,
                                );
                                isInvalid = true;
                              } else {
                                selectedTime = time;
                                isInvalid = false;
                              }
                            });
                          },
                        ),
                        hour24: true,
                      ),
                    ),
                  ),
                  if (isBeforeDeviceTime || isInvalid) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Tidak dapat memilih jam sebelum waktu saat ini ($formattedNow WIB).',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                        onPress: (isBeforeDeviceTime || isInvalid)
                            ? null
                            : () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (result == true) {
      await _scheduleAlarm(selectedTime);
    }
  }

  Future<void> _scheduleAlarm(FTime time) async {
    // Pastikan izin notifikasi dan alarm tepat waktu aktif
    final notifStatus = await Permission.notification.status;
    if (!notifStatus.isGranted) {
      await Permission.notification.request();
    }

    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (!exactAlarmStatus.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    // Pastikan optimasi baterai dinonaktifkan agar alarm tidak dimatikan di background
    final isBatteryWhitelisted =
        await AppPermissionService.isBatteryOptimizationDisabled();
    if (!isBatteryWhitelisted) {
      if (mounted) {
        await AppPermissionService.showBatteryOptimizationDialog(context);
      }
    }

    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Waktu tidak boleh lebih awal dari waktu saat ini
    if (scheduledDateTime.isBefore(now)) {
      if (mounted) {
        showFToast(
          context: context,
          title: const Text('Waktu Tidak Valid'),
          description: const Text(
            'Waktu alarm tidak boleh sebelum jam saat ini.',
          ),
          icon: const Icon(Icons.error_outline),
        );
      }
      return;
    }

    final alarmSettings = AlarmSettings(
      id: _alarmId,
      dateTime: scheduledDateTime,
      assetAudioPath: 'assets/alarm/alarm_perang.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: false,
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
        decoration: .boxDelta(color: colors.background.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Judul & Status
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: .circular(20),
              child: Image.asset(
                'assets/images/jangan_lupa_checkout_bos.png',
                width: .infinity,
                height: 200,
                fit: .cover,
              ),
            ),
            SizedBox(height: 6),
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
            SizedBox(height: 4),
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
                          'Waktu Alarm',
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
                style: typography.body.sm.copyWith(),
              ),
              const SizedBox(height: 14),
            ],

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
                      _isAlarmActive ? 'Ubah Waktu Alarm' : 'Set Waktu Alarm',
                      style: typography.body.xs.copyWith(
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
