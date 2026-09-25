import 'package:absensi_dede/absensi/views/splash_screen.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<RegisterRoute>(path: '/')
class RegisterRoute extends GoRouteData with $RegisterRoute {
  RegisterRoute({this.from});
  final String? from;

  @override
  SplashScreen build(BuildContext context, GoRouterState state) {
    return SplashScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  LoginRoute({this.from});
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(from: from);
  }
}
