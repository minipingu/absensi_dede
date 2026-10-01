import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service untuk mengelola semua runtime permission yang dibutuhkan aplikasi.
///
/// Permission yang ditangani:
/// - Lokasi (fine + coarse)
/// - Notifikasi (Android 13+)
/// - Alarm tepat waktu (exact alarm)
/// - Battery optimization (agar app tidak dimatikan di background)
class AppPermissionService {
  AppPermissionService._();

  /// Daftar permission utama yang wajib diminta saat app pertama kali dibuka.
  static const List<Permission> _requiredPermissions = [
    Permission.location,
    Permission.notification,
    Permission.scheduleExactAlarm,
  ];

  /// Minta semua permission utama sekaligus.
  /// Mengembalikan `true` jika semua permission utama sudah granted.
  static Future<bool> requestAllPermissions() async {
    final statuses = await _requiredPermissions.request();

    final allGranted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    return allGranted;
  }

  /// Minta pengecualian battery optimization (agar app tidak dimatikan di background).
  /// Membuka dialog sistem Android langsung.
  /// Mengembalikan `true` jika sudah di-whitelist.
  static Future<bool> requestBatteryOptimization() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isGranted) return true;

    final result = await Permission.ignoreBatteryOptimizations.request();
    return result.isGranted;
  }

  /// Cek apakah battery optimization sudah di-disable untuk app ini.
  static Future<bool> isBatteryOptimizationDisabled() async {
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  /// Cek apakah semua permission utama sudah granted.
  static Future<bool> areAllPermissionsGranted() async {
    for (final permission in _requiredPermissions) {
      if (!await permission.isGranted) return false;
    }
    return true;
  }

  /// Cek dan minta semua permission + battery optimization.
  /// Ideal dipanggil saat user pertama kali login atau buka home screen.
  static Future<PermissionReport> checkAndRequestAll() async {
    final permissionsGranted = await requestAllPermissions();
    final batteryOptimized = await requestBatteryOptimization();

    return PermissionReport(
      allPermissionsGranted: permissionsGranted,
      batteryOptimizationDisabled: batteryOptimized,
    );
  }

  /// Tampilkan dialog yang menjelaskan kenapa permission dibutuhkan,
  /// lalu arahkan user ke Settings jika permission ditolak permanen.
  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    if (!context.mounted) return;

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
              Text('Izin Diperlukan', style: style.titleTextStyle),
              const SizedBox(height: 8),
              Text(
                'Aplikasi membutuhkan izin berikut agar bisa berjalan dengan baik:\n\n'
                '• Lokasi — untuk absensi check in/out\n'
                '• Notifikasi — untuk pengingat alarm\n'
                '• Alarm — untuk pengingat check out\n'
                '• Baterai — agar alarm tetap berbunyi di latar belakang\n\n'
                'Buka Pengaturan untuk memberikan izin.',
                style: style.bodyTextStyle,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FButton(
                    variant: .secondary,
                    onPress: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Nanti'),
                  ),
                  const SizedBox(width: 8),
                  FButton(
                    onPress: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Buka Pengaturan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      await openAppSettings();
    }
  }

  /// Tampilkan dialog khusus untuk battery optimization.
  static Future<void> showBatteryOptimizationDialog(
    BuildContext context,
  ) async {
    if (!context.mounted) return;

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
              Row(
                children: [
                  const Icon(Icons.battery_alert, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Optimasi Baterai',
                      style: style.titleTextStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Agar alarm pengingat check out tetap berbunyi saat '
                'aplikasi ditutup atau di latar belakang, nonaktifkan '
                'optimasi baterai untuk aplikasi ini.\n\n'
                'Tanpa izin ini, Android dapat mematikan alarm saat '
                'perangkat dalam mode hemat daya.',
                style: style.bodyTextStyle,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FButton(
                    variant: .secondary,
                    onPress: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Nanti'),
                  ),
                  const SizedBox(width: 8),
                  FButton(
                    onPress: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Izinkan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true) {
      await requestBatteryOptimization();
    }
  }
}

/// Hasil laporan pengecekan permission.
class PermissionReport {
  final bool allPermissionsGranted;
  final bool batteryOptimizationDisabled;

  const PermissionReport({
    required this.allPermissionsGranted,
    required this.batteryOptimizationDisabled,
  });

  /// Apakah semua izin sudah OK (termasuk battery).
  bool get isFullyGranted =>
      allPermissionsGranted && batteryOptimizationDisabled;
}
