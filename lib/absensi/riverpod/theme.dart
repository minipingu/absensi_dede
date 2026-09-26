import 'package:absensi_dede/absensi/services/preferences_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  Future<bool> build() async {
    return await ThemePreferences.isDark;
  }

  Future<void> toggleTheme() async {
    final currentState = state.value ?? false;
    final newState = !currentState;

    state = AsyncData(newState);

    await ThemePreferences.setTheme(newState);
  }
}
