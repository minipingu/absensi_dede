import 'package:developer_mode/developer_mode.dart';
import 'package:flutter/material.dart';

import '../router/routes.dart';
import '../services/login_preferences.dart';
import 'dev_mode_check_screen.dart';

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  bool? isDeveloperMode;
  bool? isJailbroken;
  bool isChecking = true;

  AppLifecycleListener? lifecycleListener;

  @override
  void initState() {
    super.initState();

    if (DevModeCheckScreen.hasPrechecked) {
      if (DevModeCheckScreen.isDeviceSafe) {
        isChecking = false;
        isDeveloperMode = false;
        isJailbroken = false;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          final isLogin = await LoginPreferences.isLogin;
          if (!mounted) return;
          if (isLogin) {
            HomeRoute().go(context);
          } else {
            const SplashRoute().go(context);
          }
        });
        return;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          const DevModeCheckRoute().go(context);
        });
        return;
      }
    }

    checkDeveloperMode();

    lifecycleListener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.resumed) {
          checkDeveloperMode();
        }
      },
    );
  }

  Future<void> checkDeveloperMode() async {
    if (!mounted) return;
    setState(() {
      isChecking = true;
    });

    bool result = false;
    bool jailbrokenResult = false;
    try {
      result = await DeveloperMode.isDeveloperMode;
      jailbrokenResult = await DeveloperMode.isJailbroken;
    } catch (e) {
      debugPrint('Error check developer mode: $e');
    }

    DevModeCheckScreen.cachedIsDeveloperMode = result;
    DevModeCheckScreen.cachedIsJailbroken = jailbrokenResult;
    DevModeCheckScreen.isDeviceSafe = !result && !jailbrokenResult;
    DevModeCheckScreen.hasPrechecked = true;

    if (!mounted) return;

    setState(() {
      isDeveloperMode = result;
      isJailbroken = jailbrokenResult;
      isChecking = false;
    });

    if (!result && !jailbrokenResult) {
      final isLogin = await LoginPreferences.isLogin;
      if (!mounted) return;
      if (isLogin) {
        HomeRoute().go(context);
      } else {
        const SplashRoute().go(context);
      }
    } else {
      const DevModeCheckRoute().go(context);
    }
  }

  @override
  void dispose() {
    lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking || (isDeveloperMode == false && isJailbroken == false)) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/splash_screen.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (isDeveloperMode == true || isJailbroken == true)
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  size: 64,
                  color: (isDeveloperMode == true || isJailbroken == true)
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Developer Mode: ${isDeveloperMode ?? 'Tidak diketahui'} | Root: ${isJailbroken ?? 'Tidak diketahui'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => const DevModeCheckRoute().go(context),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Lanjut ke Pemeriksaan Dev Mode'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
