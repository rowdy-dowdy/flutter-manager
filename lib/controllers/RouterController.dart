import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/controllers/AuthController.dart';
import 'package:manager/models/AuthModel.dart';
import 'package:manager/pages/HomePage.dart';
import 'package:manager/pages/LoadingPage.dart';
import 'package:manager/pages/LoginPage.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  final List<String> loginPages = ["/landing", "/login"];

  RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, 
    (_, __) => notifyListeners());
  }

  String? _redirectLogin(_, GoRouterState state) {
    final authSate = _ref.read(authControllerProvider).authState;
    
    if (authSate == AuthState.initial) return null;

    final areWeLoginIn = loginPages.indexWhere((e) => e == state.subloc);

    if (authSate != AuthState.login) {
      return areWeLoginIn >= 0 ? null : '/landing';
    }

    if (areWeLoginIn >= 0 || state.subloc == "/loading") return '/';

    return null;    
  }

  List<RouteBase> get _routers => [
    GoRoute(
      name: 'loading',
      path: '/loading',
      builder: (context, state) => const LoadingPage(),
    ),

    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      // builder: (context, state, child) {
      //   return MainLayout(child: child);
      // },
      routes: [
        GoRoute(
          name: 'chat',
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ]
    )
  ];
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/loading',
    debugLogDiagnostics: true,
    refreshListenable: router,
    redirect: router._redirectLogin,
    routes: router._routers
  );
});