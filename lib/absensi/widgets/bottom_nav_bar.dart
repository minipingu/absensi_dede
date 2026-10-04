import 'package:absensi_kopdes/absensi/controllers/history_absen.dart';
import 'package:absensi_kopdes/absensi/riverpod/bottom_nav.dart';
import 'package:absensi_kopdes/absensi/riverpod/map_refresh.dart';
import 'package:absensi_kopdes/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_kopdes/absensi/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_bar/nav_bar.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context, int fallbackIndex) {
    try {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/maps')) return 1;
      if (location.startsWith('/alarm')) return 2;
      if (location.startsWith('/attendance-list')) return 3;
      if (location.startsWith('/profile')) return 4;
    } catch (_) {}
    return fallbackIndex;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerIndex = ref.watch(bottomNavProvider);
    final currentIndex = _calculateSelectedIndex(context, providerIndex);

    return FuturisticNavBar(
      items: [
        NavBarItem(icon: FLucideIcons.home, label: 'BERANDA'),
        NavBarItem(icon: FLucideIcons.map, label: 'MAPS'),
        NavBarItem(icon: FLucideIcons.alarmClock, label: 'ALARM'),
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
          ref.read(mapRefreshTriggerProvider.notifier).trigger();
          MapsRoute().go(context);
        } else if (index == 2) {
          const AlarmRoute().go(context);
        } else if (index == 3) {
          AttendanceListRoute().go(context);
        } else {
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
