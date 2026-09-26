import 'package:absensi_dede/absensi/services/theme_preferences.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemePreferences.isDarkMode,
      builder: (context, isDark, _) {
        return FSwitch(
          value: isDark,
          onChange: (value) async {
            await ThemePreferences.toggleTheme(value);
          },
        );
      },
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemePreferences.isDarkMode,
      builder: (context, isDark, _) {
        return FButton(
          onPress: () async {
            await ThemePreferences.toggleTheme(!isDark);
          },
          child: Text(isDark ? 'Light Mode' : 'Dark Mode'),
        );
      },
    );
  }
}
