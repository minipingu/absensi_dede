import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Keluar'),
      onPressed: () {
        LoginPreferences.logOut();
        LoginRegisterRoute().go(context);
      },
    );
  }
}
