import 'package:absensi_dede/absensi/riverpod/bottom_nav.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav_bar/nav_bar.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return FuturisticNavBar(
      items: [
        NavBarItem(icon: Icons.home, label: 'HOME'),
        NavBarItem(icon: Icons.map, label: 'MAPS'),
        NavBarItem(icon: Icons.check_box, label: 'ABSENSI'),
        NavBarItem(icon: Icons.person, label: 'PROFIL'),
      ],
      selectedIndex: currentIndex,
      onItemSelected: (index) {
        ref.read(bottomNavProvider.notifier).setIndex(index);

        print(currentIndex);

        index == 0
            ? HomeRoute().go(context)
            : index == 1
            ? MapsRoute().go(context)
            : index == 2
            ? AttendanceListRoute().go(context)
            : ProfileRoute().go(context);
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
