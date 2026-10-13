// =============================================================================
// DATA FLOW — Navigation and authentication
// =============================================================================
//
// 1. The app starts in main.dart. Before runApp() GetIt is initialized
//    (initDependencies) along with SharedPreferences.
//
// 2. GoRouter evaluates the redirect on every route change or on startup.
//    _redirect reads the token stored in SharedPreferences.
//
// 3. Redirect logic:
//    - No token and not on /login -> redirect to /login.
//    - Has token and on /login -> redirect to /home (already authenticated).
//    - Otherwise -> allow normal navigation.
//
// 4. After a successful login, AuthCubit persists the token in
//    SharedPreferences and calls context.go(RouteNames.home).
//    GoRouter detects the route change and the redirect no longer blocks it.
//
// 5. On logout, the page clears the token via AuthCubit.logout()
//    and calls context.go(RouteNames.login).
//    The redirect confirms there is no token and allows /login again.
// =============================================================================

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'route_names.dart';

/// App-wide GoRouter instance with an auth-aware redirect.
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

/// Centralized redirect logic, evaluated before every navigation.
Future<String?> _redirect(_, GoRouterState state) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(kAuthTokenKey);
  final hasToken = token != null && token.isNotEmpty;

  final isOnLogin = state.matchedLocation == RouteNames.login;

  if (!hasToken && !isOnLogin) {
    // No token and not on login -> redirect to login.
    return RouteNames.login;
  }

  if (hasToken && isOnLogin) {
    // Has token and on login -> already authenticated, go to home.
    return RouteNames.home;
  }

  // No redirect needed.
  return null;
}
