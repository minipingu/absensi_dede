import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/controllers/profile_user.dart';
import 'package:absensi_dede/absensi/riverpod/bottom_nav.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:nav_bar/nav_bar.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return FuturisticNavBar(
      items: [
        NavBarItem(icon: FLucideIcons.home, label: 'BERANDA'),
        NavBarItem(icon: FLucideIcons.map, label: 'PETA'),
        NavBarItem(icon: FLucideIcons.clockCheck, label: 'PRESENSI'),
        NavBarItem(icon: FLucideIcons.user2, label: 'PROFIL'),
      ],
      selectedIndex: currentIndex,
      onItemSelected: (index) {
        ref.read(bottomNavProvider.notifier).setIndex(index);

        if (index == 0) {
          ref.invalidate(userNameRiverpod);
          ref.invalidate(historyAbsenProvider);
          HomeRoute().go(context);
        } else if (index == 1) {
          MapsRoute().go(context);
        } else if (index == 2) {
          AttendanceListRoute().go(context);
        } else {
          ref.invalidate(profileUserProvider);
          ProfileRoute().go(context);
        }
      },
      style: NavBarStyle.synapse,
      theme: FuturisticTheme.molten(),
      iconAnimationType: IconAnimationType.magnetic,
      barBackgroundColor: Colors.red,
      showGlow: true,
      blurSigma: 10,
      iconLabelSpacing: 8,
    );
  }
}
