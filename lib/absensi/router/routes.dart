import 'package:absensi_kopdes/absensi/views/alarm_ringing_screen.dart';
import 'package:absensi_kopdes/absensi/views/alarm_screen.dart';
import 'package:absensi_kopdes/absensi/views/attendance_detail.dart';
import 'package:absensi_kopdes/absensi/views/dev_mode_check_screen.dart';
import 'package:absensi_kopdes/absensi/views/home_screen.dart';
import 'package:absensi_kopdes/absensi/views/login_register.dart';
import 'package:absensi_kopdes/absensi/views/maps_screen.dart';
import 'package:absensi_kopdes/absensi/views/profile_screen.dart';
import 'package:absensi_kopdes/absensi/views/security_check_screen.dart';
import 'package:absensi_kopdes/absensi/views/splash_screen.dart';
import 'package:absensi_kopdes/absensi/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<MapsBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<MapsRoute>(path: '/maps')],
    ),
    TypedStatefulShellBranch<AlarmBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<AlarmRoute>(path: '/alarm')],
    ),
    TypedStatefulShellBranch<AttendanceListBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<AttendanceListRoute>(path: '/attendance-list'),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(path: '/profile'),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(navigationShell: navigationShell),
    );
  }
}

//Branch
class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

class MapsBranchData extends StatefulShellBranchData {
  const MapsBranchData();
}

class AlarmBranchData extends StatefulShellBranchData {
  const AlarmBranchData();
}

class AttendanceListBranchData extends StatefulShellBranchData {
  const AttendanceListBranchData();
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

// Path
@TypedGoRoute<SecurityCheckRoute>(path: '/')
class SecurityCheckRoute extends GoRouteData with $SecurityCheckRoute {
  const SecurityCheckRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const SecurityCheckScreen(),
    );
  }
}

@TypedGoRoute<DevModeCheckRoute>(path: '/dev-mode-check')
class DevModeCheckRoute extends GoRouteData with $DevModeCheckRoute {
  const DevModeCheckRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const DevModeCheckScreen(),
    );
  }
}

@TypedGoRoute<SplashRoute>(path: '/splash-screen')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: const SplashScreen());
  }
}

@TypedGoRoute<LoginRegisterRoute>(path: '/login-register')
class LoginRegisterRoute extends GoRouteData with $LoginRegisterRoute {
  LoginRegisterRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginRegister();
  }
}

class HomeRoute extends GoRouteData with $HomeRoute {
  HomeRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: HomeScreen());
  }
}

class MapsRoute extends GoRouteData with $MapsRoute {
  MapsRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: const MapsScreen());
  }
}

class AlarmRoute extends GoRouteData with $AlarmRoute {
  const AlarmRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: const AlarmScreen());
  }
}

class AttendanceListRoute extends GoRouteData with $AttendanceListRoute {
  AttendanceListRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: AttendanceDetail());
  }
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  ProfileRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(key: state.pageKey, child: ProfileScreen());
  }
}

@TypedGoRoute<AlarmRingingRoute>(path: '/alarm-ringing')
class AlarmRingingRoute extends GoRouteData with $AlarmRingingRoute {
  const AlarmRingingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AlarmRingingScreen();
  }
}
