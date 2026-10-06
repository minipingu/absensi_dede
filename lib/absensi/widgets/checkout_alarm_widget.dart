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
  List<int> _selectedDays = AlarmPreferences.defaultDays;
  DateTime? _nextAlarmDateTime;
  StreamSubscription? _scheduledSub;

  @override
  void initState() {
    super.initState();
    _loadAlarmState();

    // Dengarkan perubahan alarm untuk sinkronisasi status
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
    final hour = await AlarmPreferences.alarmHour;
    final minute = await AlarmPreferences.alarmMinute;
    final days = await AlarmPreferences.alarmDays;
    final alarms = await Alarm.getAlarms();
    final isActuallyScheduled = alarms.any((a) => a.id == _alarmId);

    DateTime? nextDateTime;
    if (hour != null && minute != null && days.isNotEmpty) {
      nextDateTime = AlarmPreferences.calculateNextAlarmDateTime(
        hour: hour,
        minute: minute,
        days: days,
      );

      // Jika di preferences aktif tetapi belum terjadwal (misal setelah reboot perangkat),
      // jadwalkan ulang secara otomatis
      if (enabled && !isActuallyScheduled) {
        await AlarmPreferences.scheduleNextAlarm(
          hour: hour,
          minute: minute,
          days: days,
          id: _alarmId,
        );
      }
    }

    if (mounted) {
      setState(() {
        _alarmTime = time;
        _selectedDays = days;
        _isAlarmActive =
            enabled &&
            (isActuallyScheduled || (hour != null && minute != null));
        _nextAlarmDateTime = nextDateTime;
      });
    }
  }

  Future<void> _toggleDay(int weekday) async {
    final updatedDays = List<int>.from(_selectedDays);
    if (updatedDays.contains(weekday)) {
      if (updatedDays.length <= 1) {
        showFToast(
          context: context,
          title: const Text('Hari Tidak Dapat Dikosongkan'),
          description: const Text('Pilih minimal satu hari untuk alarm.'),
          icon: const Icon(Icons.info_outline),
        );
        return;
      }
      updatedDays.remove(weekday);
    } else {
      updatedDays.add(weekday);
      updatedDays.sort();
    }

    await AlarmPreferences.saveAlarmDays(updatedDays);

    final hour = await AlarmPreferences.alarmHour;
    final minute = await AlarmPreferences.alarmMinute;
    DateTime? nextDateTime;

    if (hour != null && minute != null) {
      nextDateTime = AlarmPreferences.calculateNextAlarmDateTime(
        hour: hour,
        minute: minute,
        days: updatedDays,
      );

      if (_isAlarmActive) {
        await AlarmPreferences.scheduleNextAlarm(
          hour: hour,
          minute: minute,
          days: updatedDays,
          id: _alarmId,
        );
      }
    }

    if (mounted) {
      setState(() {
        _selectedDays = updatedDays;
        _nextAlarmDateTime = nextDateTime;
      });

      showFToast(
        context: context,
        title: const Text('Hari Alarm Diperbarui'),
        description: Text(AlarmPreferences.formatDaysSummary(updatedDays)),
        icon: const Icon(Icons.check_circle_outline),
      );
    }
  }

  Future<void> _setPresetDays(List<int> presetDays) async {
    await AlarmPreferences.saveAlarmDays(presetDays);
    final hour = await AlarmPreferences.alarmHour;
    final minute = await AlarmPreferences.alarmMinute;
    DateTime? nextDateTime;

    if (hour != null && minute != null) {
      nextDateTime = AlarmPreferences.calculateNextAlarmDateTime(
        hour: hour,
        minute: minute,
        days: presetDays,
      );

      if (_isAlarmActive) {
        await AlarmPreferences.scheduleNextAlarm(
          hour: hour,
          minute: minute,
          days: presetDays,
          id: _alarmId,
        );
      }
    }

    if (mounted) {
      setState(() {
        _selectedDays = presetDays;
        _nextAlarmDateTime = nextDateTime;
      });

      showFToast(
        context: context,
        title: const Text('Preset Hari Diterapkan'),
        description: Text(AlarmPreferences.formatDaysSummary(presetDays)),
        icon: const Icon(Icons.check_circle_outline),
      );
    }
  }

  Future<void> _openTimePickerDialog() async {
    final now = DateTime.now();
    final savedHour = await AlarmPreferences.alarmHour ?? now.hour;
    final savedMinute = await AlarmPreferences.alarmMinute ?? now.minute;

    FTime selectedTime = FTime(savedHour, savedMinute);
    List<int> dialogDays = List<int>.from(_selectedDays);

    if (!mounted) return;

    final result = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        animation: animation,
        builder: (dialogContext, style) => StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final deviceNow = DateTime.now();

            // Hitung jadwal berikutnya secara real-time
            final nextOccurrence = dialogDays.isNotEmpty
                ? AlarmPreferences.calculateNextAlarmDateTime(
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                    days: dialogDays,
                  )
                : null;

            final formattedNow =
                '${deviceNow.hour.toString().padLeft(2, '0')}:${deviceNow.minute.toString().padLeft(2, '0')}';

            final isTodayOnly =
                dialogDays.length == 1 &&
                dialogDays.contains(deviceNow.weekday);
            final isPastForTodayOnly =
                isTodayOnly &&
                (selectedTime.hour < deviceNow.hour ||
                    (selectedTime.hour == deviceNow.hour &&
                        selectedTime.minute < deviceNow.minute));

            final isDaysEmpty = dialogDays.isEmpty;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Atur Waktu Pengingat', style: style.titleTextStyle),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih jam dan hari untuk menyetel alarm check out.',
                      style: style.bodyTextStyle,
                    ),
                    const SizedBox(height: 14),

                    // Pemilihan Jam & Menit
                    Center(
                      child: SizedBox(
                        height: 160,
                        child: FTimePicker(
                          control: .lifted(
                            time: selectedTime,
                            onChange: (time) {
                              setDialogState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                          hour24: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Header Pemilihan Hari
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Hari Alarm:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  dialogDays = List<int>.from(
                                    AlarmPreferences.defaultDays,
                                  );
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Hari Kerja',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  dialogDays = List<int>.from(
                                    AlarmPreferences.allDays,
                                  );
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Semua',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 7 Chip Hari (Senin - Minggu)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: AlarmPreferences.allDays.map((weekday) {
                        final isSelected = dialogDays.contains(weekday);
                        final shortName = AlarmPreferences.getDayShortName(
                          weekday,
                        );

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              if (isSelected) {
                                if (dialogDays.length > 1) {
                                  dialogDays.remove(weekday);
                                }
                              } else {
                                dialogDays.add(weekday);
                                dialogDays.sort();
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.withValues(alpha: 0.15),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              shortName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 8),

                    // Teks Ringkasan Hari
                    Text(
                      AlarmPreferences.formatDaysSummary(dialogDays),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Informasi Jadwal Alarm Berikutnya
                    if (isDaysEmpty) ...[
                      const Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Pilih minimal 1 hari aktif.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isPastForTodayOnly) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Jam hari ini telah lewat ($formattedNow WIB). Alarm akan berdering minggu depan.',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (nextOccurrence != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.alarm_on,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Alarm berikutnya: ${_formatNextAlarm(nextOccurrence)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Tombol Aksi
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
                          onPress: isDaysEmpty
                              ? null
                              : () {
                                  _selectedDays = dialogDays;
                                  Navigator.of(dialogContext).pop(true);
                                },
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (result == true) {
      await _scheduleAlarm(selectedTime, _selectedDays);
    }
  }

  Future<void> _scheduleAlarm(FTime time, List<int> days) async {
    // Pastikan izin notifikasi dan alarm tepat waktu aktif
    final notifStatus = await Permission.notification.status;
    if (!notifStatus.isGranted) {
      await Permission.notification.request();
    }

    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (!exactAlarmStatus.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    // Pastikan optimasi baterai dinonaktifkan
    final isBatteryWhitelisted =
        await AppPermissionService.isBatteryOptimizationDisabled();
    if (!isBatteryWhitelisted) {
      if (mounted) {
        await AppPermissionService.showBatteryOptimizationDialog(context);
      }
    }

    final success = await AlarmPreferences.scheduleNextAlarm(
      hour: time.hour,
      minute: time.minute,
      days: days,
      id: _alarmId,
    );

    if (success) {
      await AlarmPreferences.saveAlarm(
        hour: time.hour,
        minute: time.minute,
        selectedDays: days,
        id: _alarmId,
      );

      final nextDateTime = AlarmPreferences.calculateNextAlarmDateTime(
        hour: time.hour,
        minute: time.minute,
        days: days,
      );

      final formatted24h =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      if (mounted) {
        setState(() {
          _alarmTime = formatted24h;
          _selectedDays = days;
          _isAlarmActive = true;
          _nextAlarmDateTime = nextDateTime;
        });

        showFToast(
          context: context,
          title: const Text('Alarm Berhasil Diatur'),
          description: Text(
            'Pengingat disetel untuk pukul $formatted24h WIB (${AlarmPreferences.formatDaysSummary(days)})',
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

  Future<void> _activateAlarm() async {
    final hour = await AlarmPreferences.alarmHour;
    final minute = await AlarmPreferences.alarmMinute;
    final days = await AlarmPreferences.alarmDays;

    if (hour != null && minute != null) {
      await _scheduleAlarm(FTime(hour, minute), days);
    } else {
      await _openTimePickerDialog();
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
        title: const Text('Alarm Dimatikan'),
        description: const Text('Pengingat check out telah dimatikan.'),
        icon: const Icon(Icons.alarm_off),
      );
    }
  }

  String _formatNextAlarm(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow =
        dt.year == tomorrow.year &&
        dt.month == tomorrow.month &&
        dt.day == tomorrow.day;

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} WIB';

    if (isToday) {
      return 'Hari ini pukul $timeStr';
    } else if (isTomorrow) {
      return 'Besok (${AlarmPreferences.getDayName(dt.weekday)}) pukul $timeStr';
    } else {
      return '${AlarmPreferences.getDayName(dt.weekday)}, ${dt.day} ${_getMonthName(dt.month)} pukul $timeStr';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return month >= 1 && month <= 12 ? months[month] : '';
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
            // Header Image
            ClipRRect(
              borderRadius: .circular(20),
              child: Image.asset(
                'assets/images/jangan_lupa_checkout_bos.png',
                width: .infinity,
                fit: .cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul & Badge Status
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

            // Box Waktu Alarm & Jadwal Berikutnya
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    if (_nextAlarmDateTime != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Alarm berikutnya: ${_formatNextAlarm(_nextAlarmDateTime!)}',
                              style: typography.body.xs.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Atur pengingat agar tidak lupa melakukan check out setelah jam kerja selesai.',
                      style: typography.body.sm,
                    ),
                  ),
                  if (_alarmTime != null) ...[
                    const SizedBox(width: 8),
                    FButton(
                      variant: .outline,
                      onPress: _activateAlarm,
                      child: const Text('Aktifkan'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Section Pilihan Hari (Senin - Minggu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilihan Hari:',
                  style: typography.body.sm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _setPresetDays(AlarmPreferences.defaultDays),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Hari Kerja',
                          style: typography.body.xs.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _setPresetDays(AlarmPreferences.allDays),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Semua',
                          style: typography.body.xs.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 7 Chip Hari (Senin - Minggu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: AlarmPreferences.allDays.map((weekday) {
                final isSelected = _selectedDays.contains(weekday);
                final shortName = AlarmPreferences.getDayShortName(weekday);

                return GestureDetector(
                  onTap: () => _toggleDay(weekday),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colors.primary
                          : colors.muted.withValues(alpha: 0.2),
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : colors.muted.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      shortName,
                      style: typography.body.xs.copyWith(
                        color: isSelected
                            ? colors.primaryForeground
                            : colors.mutedForeground,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // Teks Keterangan Hari
            Text(
              AlarmPreferences.formatDaysSummary(_selectedDays),
              style: typography.body.xs.copyWith(
                color: colors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Set / Ubah Waktu Alarm
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
