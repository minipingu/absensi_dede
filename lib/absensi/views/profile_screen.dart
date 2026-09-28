import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider).value ?? false;

    return Scaffold(
      extendBody: true,
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                themeState
                    ? 'assets/images/kopdes_gunung_malam.png'
                    : 'assets/images/kopdes_gunung.png',
                fit: .cover,
              ),
            ),
            ListView(
              children: [
                Text(
                  'data profile, dibuat dan diupdate, edit profil, logout, theme app',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
