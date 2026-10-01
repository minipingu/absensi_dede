import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../router/routes.dart';
import '../services/alarm_preferences.dart';
import '../services/login_preferences.dart';

class AlarmScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const AlarmScreen({super.key, this.alarmSettings});

  static bool isVisible = false;

  /// Helper untuk menampilkan AlarmScreen dari mana saja
  static Future<void> show(
    BuildContext context, {
    AlarmSettings? settings,
  }) async {
    if (isVisible) return;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => AlarmScreen(alarmSettings: settings),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  late DateTime _currentTime;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  bool _isStopping = false;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    AlarmScreen.isVisible = true;
    _currentTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    AlarmScreen.isVisible = false;
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _stopAlarm() async {
    if (_isStopping) return;
    setState(() {
      _isStopping = true;
    });

    try {
      final alarmId =
          widget.alarmSettings?.id ?? await AlarmPreferences.alarmId;
      await Alarm.stop(alarmId);
      await Alarm.stopAll();
      await AlarmPreferences.clearAlarm();
    } catch (_) {
      try {
        await Alarm.stopAll();
      } catch (_) {}
    }

    if (mounted) {
      showFToast(
        context: context,
        title: const Text('Alarm Dimatikan'),
        description: const Text('Pengingat check out telah dihentikan.'),
        icon: const Icon(Icons.alarm_off),
      );

      setState(() {
        _canPop = true;
      });

      final isLogin = await LoginPreferences.isLogin;
      if (!mounted) return;

      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        if (isLogin) {
          HomeRoute().go(context);
        } else {
          LoginRegisterRoute().go(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typography = context.theme.typography;

    final formattedTime = DateFormat('HH:mm:ss').format(_currentTime);
    final formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(_currentTime);

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _stopAlarm();
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header
                Column(
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.alarm,
                          size: 72,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'PENGINGAT CHECK OUT',
                      style: typography.display.sm.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Saatnya melakukan absensi pulang / check out!',
                      textAlign: TextAlign.center,
                      style: typography.body.md.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                // Jam Format 24 Jam
                FCard(
                  style: .delta(
                    decoration: .boxDelta(
                      color: colors.muted.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 24,
                    ),
                    child: Column(
                      children: [
                        Text(
                          formattedTime,
                          style: typography.display.xl2.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: typography.body.sm.copyWith(
                            color: colors.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tombol Matikan Alarm
                SizedBox(
                  width: double.infinity,
                  child: FButton(
                    variant: .primary,
                    onPress: _isStopping ? null : _stopAlarm,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.alarm_off),
                        const SizedBox(width: 8),
                        Text(
                          _isStopping ? 'Mematikan...' : 'Matikan Alarm',
                          style: typography.body.lg.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
