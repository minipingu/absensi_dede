import 'dart:async';

import 'package:absensi_kopdes/absensi/router/routes.dart';
import 'package:alarm/alarm.dart';
import 'package:developer_mode/developer_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'absensi/riverpod/theme.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(navigatorKey: rootNavigatorKey, routes: $appRoutes);

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
  StreamSubscription<dynamic>? _ringSubscription;
  late final AppLifecycleListener _lifecycleListener;
  bool _isCheckingSecurity = false;

  @override
  void initState() {
    super.initState();

    // 1. Pengawasan lifecycle secara global saat aplikasi kembali ke status resumed
    _lifecycleListener = AppLifecycleListener(
      onResume: _checkDeviceSecurityOnResume,
    );

    // 2. Listen to ringing alarms stream (alarm v5 API: ValueStream<AlarmSet>)
    _ringSubscription = Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isNotEmpty) {
        // Use post-frame to ensure router is mounted and ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentPath =
              _router.routerDelegate.currentConfiguration.uri.path;
          if (currentPath != '/alarm-ringing') {
            _router.go('/alarm-ringing');
          }
        });
      }
    });

    // Check if alarm is already ringing on startup (ValueStream has current value)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Alarm.ringing.value.alarms.isNotEmpty) {
        _router.go('/alarm-ringing');
      }
    });
  }

  /// Verifikasi keamanan perangkat saat aplikasi di-resume dari background
  Future<void> _checkDeviceSecurityOnResume() async {
    if (_isCheckingSecurity) return;
    _isCheckingSecurity = true;

    try {
      final isDeveloperMode = await DeveloperMode.isDeveloperMode;
      final isJailbroken = await DeveloperMode.isJailbroken;

      if (isDeveloperMode || isJailbroken) {
        final currentPath =
            _router.routerDelegate.currentConfiguration.uri.path;

        // Cegah loop: hanya redirect jika belum berada di /dev-mode-check atau /
        if (currentPath != '/dev-mode-check' && currentPath != '/') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _router.go('/dev-mode-check');
          });
        }
      }
    } catch (e) {
      debugPrint('Security check error on resume: $e');
    } finally {
      _isCheckingSecurity = false;
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
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
      builder: (context, child) {
        final features =
            WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
        return FTheme(
          data: themeState ? darkTheme : lightTheme,
          accessibility: FAccessibility(
            accessibleNavigation: false,
            motion: features.disableAnimations
                ? FAccessibilityMotion.disabled
                : features.reduceMotion
                ? FAccessibilityMotion.reduced
                : FAccessibilityMotion.all,
            focusHighlight:
                FocusManager.instance.highlightMode ==
                FocusHighlightMode.traditional,
          ),
          child: FToaster(child: FTooltipGroup(child: child!)),
        );
      },
    );
  }
}
