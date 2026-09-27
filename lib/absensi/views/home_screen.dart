import 'package:absensi_dede/absensi/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Stack(), bottomNavigationBar: BottomNavBar());
  }
}
