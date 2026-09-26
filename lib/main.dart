import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/preferences_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'absensi/riverpod/theme.dart';
import 'theme/theme.dart';

final _router = GoRouter(routes: $appRoutes);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: Application()));
}

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider).value ?? false;

    return MaterialApp.router(
      routerConfig: _router,
      themeMode: themeState ? ThemeMode.dark : ThemeMode.light,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      theme: lightTheme.toApproximateMaterialTheme(),
      darkTheme: darkTheme.toApproximateMaterialTheme(),
      builder: (context, child) => FTheme(
        data: themeState ? darkTheme : lightTheme,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
    );
  }
}
