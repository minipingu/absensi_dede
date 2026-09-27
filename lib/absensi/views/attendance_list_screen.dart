import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AttendanceListScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Absensi')),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
