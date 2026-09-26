import 'dart:async';

import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/preferences_login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Timer(Duration(seconds: 3), () async {
        await PreferencesLogin.isLogin
            ? HomeRoute().go(context)
            : LoginRegisterRoute().go(context);
      });
      return null;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/splash_screen.jpg', fit: .cover),
          ),
          Positioned(
            bottom: 500,
            left: 100,
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'now loading...',
                  speed: Duration(milliseconds: 100),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 30,
                    fontWeight: .w800,
                    fontStyle: .italic,
                  ),
                  colors: [
                    const Color.fromARGB(255, 255, 0, 0),
                    const Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ],
              isRepeatingAnimation: true,
              // onTap: () {
              //   print("Tap Event");
              // },
            ),
          ),
        ],
      ),
    );
  }
}
