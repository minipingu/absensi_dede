import 'dart:async';

import 'package:absensi_kopdes/absensi/router/routes.dart';
import 'package:absensi_kopdes/absensi/services/login_preferences.dart';
import 'package:absensi_kopdes/absensi/views/dev_mode_check_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final timer = Timer(const Duration(seconds: 3), () async {
        if (!context.mounted) return;

        // Jika dev mode atau root aktif saat timer selesai, arahkan ke peringatan
        if (!DevModeCheckScreen.isDeviceSafe) {
          const DevModeCheckRoute().go(context);
          return;
        }

        final isLogin = await LoginPreferences.isLogin;
        if (context.mounted) {
          if (isLogin) {
            HomeRoute().go(context);
          } else {
            LoginRegisterRoute().go(context);
          }
        }
      });
      return timer.cancel;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 500,
            left: 100,
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'now loading...',
                  speed: const Duration(milliseconds: 100),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                  colors: [
                    const Color.fromARGB(255, 255, 0, 0),
                    const Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ],
              isRepeatingAnimation: true,
            ),
          ),
        ],
      ),
    );
  }
}
