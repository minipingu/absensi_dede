import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/theme_preferences.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'theme/theme.dart';

final _router = GoRouter(routes: $appRoutes);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemePreferences.init();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemePreferences.isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp.router(
          routerConfig: _router,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          supportedLocales: FLocalizations.supportedLocales,
          localizationsDelegates: const [
            ...FLocalizations.localizationsDelegates,
          ],
          theme: lightTheme.toApproximateMaterialTheme(),
          darkTheme: darkTheme.toApproximateMaterialTheme(),
          builder: (context, child) => FTheme(
            data: isDark ? darkTheme : lightTheme,
            child: FToaster(child: FTooltipGroup(child: child!)),
          ),
        );
      },
    );
  }
}
