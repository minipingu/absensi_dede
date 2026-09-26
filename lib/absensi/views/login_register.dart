import 'package:absensi_dede/absensi/widgets/form_auth.dart';
import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegister extends HookWidget {
  const LoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/images/kopdes_malam.jpeg'
                  : 'assets/images/login_kopdes.jpeg',
              fit: .cover,
            ),
          ),
          ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              top: 120,
              bottom: 120,
              left: 20,
              right: 20,
            ),
            children: [
              Column(
                spacing: 20,
                children: [
                  SizedBox(
                    child: FCard(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(20),
                        child: Column(
                          spacing: 20,
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              'Absensi Manager Kopdes',
                              style: typography.body.lg,
                            ),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    20,
                                  ),
                                  child: Image.asset(
                                    !isDark
                                        ? 'assets/images/pegawai_malam.jpeg'
                                        : 'assets/images/pegawai_kopdes.jpeg',
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: ThemeToggleButton(),
                                ),
                              ],
                            ),
                            FormAuth(),
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text('Belum Punya akun?'),
                                FButton(
                                  size: .xs,
                                  variant: .ghost,
                                  mainAxisSize: .min,
                                  onPress: () {},
                                  child: const Text('Register'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
