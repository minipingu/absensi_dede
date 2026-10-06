import 'package:developer_mode/developer_mode.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../router/routes.dart';
import '../services/login_preferences.dart';

class DevModeCheckScreen extends StatefulWidget {
  const DevModeCheckScreen({super.key});

  @override
  State<DevModeCheckScreen> createState() => _DevModeCheckScreenState();
}

class _DevModeCheckScreenState extends State<DevModeCheckScreen> {
  bool? _isJailbroken;
  bool? _isDeveloperMode;
  bool _isLoading = true;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _checkSecurity();

    // Otomatis periksa ulang saat pengguna kembali dari pengaturan (resumed)
    _lifecycleListener = AppLifecycleListener(
      onResume: _checkSecurity,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _checkSecurity() async {
    setState(() {
      _isLoading = true;
    });

    bool isJailbroken = false;
    bool isDeveloperMode = false;

    try {
      isJailbroken = await DeveloperMode.isJailbroken;
      isDeveloperMode = await DeveloperMode.isDeveloperMode;
    } catch (e) {
      debugPrint('Error checking security: $e');
    }

    if (!mounted) return;

    setState(() {
      _isJailbroken = isJailbroken;
      _isDeveloperMode = isDeveloperMode;
      _isLoading = false;
    });

    // Jika perangkat bersih dari jailbreak dan developer mode, lanjutkan
    if (!isJailbroken && !isDeveloperMode) {
      final isLogin = await LoginPreferences.isLogin;
      if (!mounted) return;
      if (isLogin) {
        HomeRoute().go(context);
      } else {
        const SplashRoute().go(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typography = context.theme.typography;

    if (_isLoading) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Memeriksa keamanan perangkat...',
                  style: typography.body.md.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mohon tunggu sebentar',
                  style: typography.body.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isJailbroken = _isJailbroken ?? false;
    final isDeveloperMode = _isDeveloperMode ?? false;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 24),
                // Card peringatan keamanan
                FCard(
                  style: .delta(
                    decoration: .boxDelta(
                      color: colors.muted.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.gpp_bad_rounded,
                            size: 64,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Peringatan Keamanan',
                          style: typography.display.sm.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aplikasi Absensi Manager Kopdes tidak dapat dijalankan karena terdeteksi potensi celah keamanan pada perangkat ini.',
                          style: typography.body.sm.copyWith(
                            color: colors.mutedForeground,
                            fontWeight: .w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (isJailbroken)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Perangkat terdeteksi Root / Jailbreak.',
                                    style: typography.body.xs.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isDeveloperMode)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.developer_mode,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Mode Pengembang Anda aktif.',
                                    style: typography.body.xs.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Silakan nonaktifkan Mode Pengembang (Developer Options) pada pengaturan perangkat Anda dan pastikan perangkat tidak di-root, lalu coba kembali.',
                          style: typography.body.xs.copyWith(
                            color: colors.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol Periksa Ulang
                SizedBox(
                  width: double.infinity,
                  child: FButton(
                    variant: .primary,
                    onPress: _checkSecurity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh, size: 20),
                        const SizedBox(width: 8),
                        Text('Periksa Ulang'),
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
