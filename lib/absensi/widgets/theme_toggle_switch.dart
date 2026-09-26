import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider).value ?? false;

    return FButton.icon(
      onPress: () async {
        await ref.read(themeProvider.notifier).toggleTheme();
      },
      child: isDark
          ? const Icon(FLucideIcons.sun)
          : const Icon(FLucideIcons.moon),
    );
  }
}
