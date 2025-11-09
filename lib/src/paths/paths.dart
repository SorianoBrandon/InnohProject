import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/home_view.dart';
import 'package:innohproject/src/Views/start_view.dart';

final paths = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'Inicio', builder: (context, state) => HomeView()),
    GoRoute(
      path: '/manager',
      name: 'Gerente',
      builder: (context, state) => StartView(),
    ),
  ],
);
