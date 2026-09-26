import 'package:absensi_dede/absensi/views/home_screen.dart';
import 'package:absensi_dede/absensi/views/login_register.dart';
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

@TypedGoRoute<LoginRegisterRoute>(path: '/register')
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
