import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class LoginRegister extends StatefulWidget {
  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/login_kopdes.jpeg', fit: .cover),
        ),
        SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(top: 200, left: 20, right: 20),
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
                            ThemeToggleButton(),
                            Text(
                              'Absensi Manager Kopdes',
                              style: TextStyle(color: Colors.white),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(20),
                              child: Image.asset(
                                'assets/images/pegawai_kopdes.png',
                              ),
                            ),
                            Form(
                              key: _key,
                              child: Column(
                                children: [
                                  FTextFormField.email(
                                    hint: 'misal : manager@kopdes.com',
                                    autovalidateMode: .onUserInteraction,
                                    validator: (value) =>
                                        (value?.contains('@') ?? false)
                                        ? null
                                        : 'Please enter a valid email.',
                                  ),
                                  const SizedBox(height: 10),
                                  FTextFormField.password(
                                    hint: 'misal : isi password',
                                    autovalidateMode: .onUserInteraction,
                                    validator: (value) =>
                                        8 <= (value?.length ?? 0) ? null : 'Password must be at least 8 characters long.',
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: .infinity,
                                    child: FButton(
                                      size: .sm,
                                      mainAxisSize: .min,
                                      child: const Text('Login'),
                                      onPress: () {
                                        if (_key.currentState!.validate()) {
                                          // Form is valid, do something.
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  'Belum Punya akun?',
                                  style: TextStyle(color: Colors.white),
                                ),
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
        ),
      ],
    ),
  );
}
