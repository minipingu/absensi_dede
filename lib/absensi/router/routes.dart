import 'package:absensi_kopdes/absensi/views/alarm_ringing_screen.dart';
import 'package:absensi_kopdes/absensi/views/alarm_screen.dart';
import 'package:absensi_kopdes/absensi/views/attendance_detail.dart';
import 'package:absensi_kopdes/absensi/views/home_screen.dart';
import 'package:absensi_kopdes/absensi/views/login_register.dart';
import 'package:absensi_kopdes/absensi/views/maps_screen.dart';
import 'package:absensi_kopdes/absensi/views/profile_screen.dart';
import 'package:absensi_kopdes/absensi/views/splash_screen.dart';
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
    return navigationShell;
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
@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashScreen();
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

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData with $HomeRoute {
  HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen();
  }
}

@TypedGoRoute<MapsRoute>(path: '/maps')
class MapsRoute extends GoRouteData with $MapsRoute {
  MapsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MapsScreen();
  }
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  ProfileRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileScreen();
  }
}

@TypedGoRoute<AttendanceListRoute>(path: '/attendance-list')
class AttendanceListRoute extends GoRouteData with $AttendanceListRoute {
  AttendanceListRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AttendanceDetail();
  }
}

@TypedGoRoute<AlarmRoute>(path: '/alarm')
class AlarmRoute extends GoRouteData with $AlarmRoute {
  const AlarmRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AlarmScreen();
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
