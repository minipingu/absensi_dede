import 'dart:async';

import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'absensi/riverpod/theme.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: $appRoutes,
  redirect: (context, state) {
    final isAlarmRinging = Alarm.ringing.value.alarms.isNotEmpty;
    final isAlarmPath = state.uri.path == '/alarm';

    if (isAlarmRinging && !isAlarmPath) {
      return '/alarm';
    }
    return null;
  },
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await initializeDateFormatting('id_ID', null);
  runApp(const ProviderScope(child: Application()));
}

class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  @override
  ConsumerState<Application> createState() => _ApplicationState();
}

class _ApplicationState extends ConsumerState<Application> {
  StreamSubscription? _ringSubscription;

  @override
  void initState() {
    super.initState();
    _ringSubscription = Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isNotEmpty) {
        _router.go('/alarm');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Alarm.ringing.value.alarms.isNotEmpty) {
        _router.go('/alarm');
      }
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider).value ?? false;

    return MaterialApp.router(
      routerConfig: _router,
      themeMode: themeState ? ThemeMode.dark : ThemeMode.light,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...FLocalizations.localizationsDelegates,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: lightTheme.toApproximateMaterialTheme(),
      darkTheme: darkTheme.toApproximateMaterialTheme(),
      builder: (context, child) => FTheme(
        data: themeState ? darkTheme : lightTheme,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
    );
  }
}
