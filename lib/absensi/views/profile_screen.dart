import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'data profile, dibuat dan diupdate, edit profil, logout, theme app',
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
