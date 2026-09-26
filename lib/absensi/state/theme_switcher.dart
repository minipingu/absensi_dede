import 'package:absensi_dede/absensi/services/preferences_theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class ThemeState extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  Future<void> init() async {
    final isDark = await ThemePreferences.getTheme();
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme(bool value) async {
    state = value ? ThemeMode.dark : ThemeMode.light;
    await ThemePreferences.setTheme(value);
  }
}

final themeProvider = NotifierProvider<ThemeState, ThemeMode>(ThemeState.new);
