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
import 'absensi/services/login_preferences.dart';
import 'absensi/views/dev_mode_check_screen.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: $appRoutes,
  redirect: (context, state) {
    final path = state.uri.path;
    if (path == '/') {
      // Jika devmode tidak aktif dan tidak jailbroken, langsung arahkan ke /splash-screen
      // Jika tidak aman, langsung arahkan ke /dev-mode-check
      if (DevModeCheckScreen.isDeviceSafe) {
        return '/splash-screen';
      } else {
        return '/dev-mode-check';
      }
    }
    // Jika perangkat terdeteksi tidak aman dan mencoba ke layar lain, paksa ke /dev-mode-check
    if (!DevModeCheckScreen.isDeviceSafe && path != '/dev-mode-check') {
      return '/dev-mode-check';
    }
    return null;
  },
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await initializeDateFormatting('id_ID', null);

  // Pre-check status keamanan sebelum runApp agar tidak terjadi flashing saat aplikasi mulai
  await DevModeCheckScreen.precheckSecurity();

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

      DevModeCheckScreen.cachedIsDeveloperMode = isDeveloperMode;
      DevModeCheckScreen.cachedIsJailbroken = isJailbroken;
      DevModeCheckScreen.isDeviceSafe = !isDeveloperMode && !isJailbroken;
      DevModeCheckScreen.hasPrechecked = true;

      final currentPath = _router.routerDelegate.currentConfiguration.uri.path;

      if (isDeveloperMode || isJailbroken) {
        if (currentPath != '/dev-mode-check') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _router.go('/dev-mode-check');
          });
        }
      } else {
        // Jika sebelumnya berada di layar peringatan dan sekarang sudah aman,
        // kembalikan ke home (jika sudah login) atau splash
        if (currentPath == '/dev-mode-check') {
          final isLogin = await LoginPreferences.isLogin;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isLogin) {
              _router.go('/home');
            } else {
              _router.go('/splash-screen');
            }
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
