import 'dart:async';

import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      RegisterRoute().go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: .infinity,
        height: .infinity,
        child: Image.asset('assets/images/splash_screen.jpg', fit: .cover),
      ),
    );
  }
}
