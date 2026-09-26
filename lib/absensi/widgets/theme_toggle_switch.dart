import 'package:absensi_dede/absensi/services/preferences_theme.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

typedef ThemeCallback = void Function(bool isDark);

// theme toggle
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemePreferences().isDarkMode,
      builder: (context, isDark, _) {
        return FButton.icon(
          onPress: () async {
            await ThemePreferences.setTheme(!isDark);
          },
          child: isDark ? Icon(FLucideIcons.sun) : Icon(FLucideIcons.moon),
        );
      },
    );
  }
}
