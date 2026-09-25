import 'package:absensi_dede/absensi/views/register_screen.dart';
import 'package:absensi_dede/absensi/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashScreen();
  }
}

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData with $RegisterRoute {
  RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterScreen();
  }
}
