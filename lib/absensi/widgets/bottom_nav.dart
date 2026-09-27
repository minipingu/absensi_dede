import 'package:flutter/material.dart';
import 'package:nav_bar/nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const new({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FuturisticNavBar(
      items: [
        NavBarItem(icon: Icons.home, label: 'HOME'),
        NavBarItem(icon: Icons.map, label: 'MAPS'),
        NavBarItem(icon: Icons.check_box, label: 'ABSENSI'),
        NavBarItem(icon: Icons.person, label: 'PROFIL'),
      ],
      selectedIndex: _selectedIndex,
      onItemSelected: (i) => setState(() => _selectedIndex = i),
      style: NavBarStyle.synapse,
      theme: FuturisticTheme.molten(),
      iconAnimationType: IconAnimationType.magnetic,
      showGlow: true,
    );
  }
}
