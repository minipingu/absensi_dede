import 'package:flutter/material.dart';
import 'package:developer_mode/developer_mode.dart';

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  bool? _isJailbroken;
  bool? _isDeveloperMode;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    final isJailbroken = await DeveloperMode.isJailbroken;
    final isDeveloperMode = await DeveloperMode.isDeveloperMode;

    if (!mounted) return;

    setState(() {
      _isJailbroken = isJailbroken;
      _isDeveloperMode = isDeveloperMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Check')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jailbroken/Rooted: ${_isJailbroken ?? "Checking..."}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Developer Mode/Emulator: ${_isDeveloperMode ?? "Checking..."}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _checkSecurity,
              child: const Text('Re-check'),
            ),
          ],
        ),
      ),
    );
  }
}
