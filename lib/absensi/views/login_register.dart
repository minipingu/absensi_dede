import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/widgets/form_auth.dart';
import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginRegister extends HookConsumerWidget {
  const LoginRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;

    final isRegister = useState(false);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              themeState
                  ? 'assets/images/kopdes_malam.jpeg'
                  : 'assets/images/login_kopdes.jpeg',
              fit: .cover,
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Column(
                      spacing: 20,
                      children: [
                        SizedBox(
                          child: FCard(
                            style: .delta(
                              decoration: .boxDelta(
                                color: context.theme.colors.background
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(20),
                              child: Column(
                                spacing: 20,
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    'Absensi Manager Kopdes 🫡',
                                    style: typography.body.lg.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(20),
                                        child: Image.asset(
                                          themeState
                                              ? 'assets/images/pegawai_malam.png'
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
                                  FormAuth(isRegister: isRegister.value),
                                  Row(
                                    mainAxisAlignment: .center,
                                    children: [
                                      Text(
                                        isRegister.value
                                            ? 'Sudah punya akun?'
                                            : 'Belum punya akun?',
                                        style: typography.body.xs,
                                      ),
                                      FButton(
                                        size: .xs,
                                        variant: .ghost,
                                        mainAxisSize: .min,
                                        onPress: () {
                                          isRegister.value = !isRegister.value;
                                        },
                                        child: Text(
                                          isRegister.value ? 'Masuk' : 'Daftar',
                                        ),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
