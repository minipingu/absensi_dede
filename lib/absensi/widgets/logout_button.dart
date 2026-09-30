import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/controllers/login_user.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FButton(
      variant: .outline,
      child: const Text('Keluar dari aplikasi'),
      onPress: () async {
        await LoginPreferences.logOut();

        // Invalidate state akun lama di Riverpod agar data bersih
        ref.invalidate(userNameRiverpod);
        ref.invalidate(historyAbsenProvider);
        ref.invalidate(loginUserProvider);

        if (!context.mounted) return;

        showFToast(
          context: context,
          duration: const Duration(seconds: 4),
          title: const Text('Berhasil logout'),
          description: const Text('Silahkan login kembali'),
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        );

        LoginRegisterRoute().go(context);
      },
    );
  }
}
