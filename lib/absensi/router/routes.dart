import 'package:absensi_dede/absensi/views/alarm_screen.dart';
import 'package:absensi_dede/absensi/views/attendance_list_screen.dart';
import 'package:absensi_dede/absensi/views/home_screen.dart';
import 'package:absensi_dede/absensi/views/login_register.dart';
import 'package:absensi_dede/absensi/views/profile_screen.dart';
import 'package:absensi_dede/absensi/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<HomeRoute>(path: '/home')],
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
    return AttendanceListScreen();
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
