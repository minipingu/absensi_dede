import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:absensi_dede/helper/greetings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;
    final userName = ref.watch(userNameRiverpod);

    final salam = DateTime.now().greetingMessage;

    return Scaffold(
      extendBody: true,
      body: Stack(
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
              Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: FCard(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(20),
                            child: Image.asset(
                              themeState
                                  ? 'assets/images/banner_kopdes_malam.png'
                                  : 'assets/images/banner_kopdes.png',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.all(20),
                            child: Column(
                              spacing: 0,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  'Halo $salam,',
                                  style: typography.body.lg.copyWith(
                                    fontWeight: .w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(0, -6),
                                  child: userName.when(
                                    loading: () => const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    error: (err, stack) => Text(
                                      'Guest',
                                      style: typography.body.lg,
                                    ),
                                    data: (name) => Text(
                                      name ?? 'Guest',
                                      textAlign: .start,
                                      style: typography.body.lg.copyWith(
                                        fontWeight: .w800,
                                        fontSize: 30,
                                        color: const Color.fromARGB(
                                          255,
                                          219,
                                          15,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: ThemeToggleButton(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(child: Text('halo, presensi terakhir, waktu, absen sekarang')),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
