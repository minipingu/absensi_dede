import 'dart:async';

import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      RegisterRoute().go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
