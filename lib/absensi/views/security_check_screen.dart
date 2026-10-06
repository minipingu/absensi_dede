import 'package:developer_mode/developer_mode.dart';
import 'package:flutter/material.dart';

import '../router/routes.dart';

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  bool? isDeveloperMode;
  bool isChecking = true;

  late final AppLifecycleListener lifecycleListener;

  @override
  void initState() {
    super.initState();

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
    bool jailbroken = false;
    try {
      result = await DeveloperMode.isDeveloperMode;
      jailbroken = await DeveloperMode.isJailbroken;
    } catch (e) {
      debugPrint('Error check developer mode: $e');
    }

    if (!mounted) return;

    setState(() {
      isDeveloperMode = result;
      isChecking = false;
    });

    // Berikan jeda sejenak untuk animasi transisi halus,
    // lalu arahkan ke DevModeCheckScreen untuk verifikasi & peringatan komprehensif
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    const DevModeCheckRoute().go(context);
  }

  @override
  void dispose() {
    lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isChecking) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Memeriksa Keamanan Sistem...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ] else ...[
                  Icon(
                    isDeveloperMode == true
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    size: 64,
                    color: isDeveloperMode == true ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Developer Mode: ${isDeveloperMode ?? 'Tidak diketahui'}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
