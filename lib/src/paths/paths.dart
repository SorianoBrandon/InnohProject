import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/client_view.dart';
import 'package:innohproject/src/Views/home_view.dart';
import 'package:innohproject/src/Views/start_view.dart';
import 'package:innohproject/src/models/mdl_client.dart';
import 'package:innohproject/src/models/mdl_employ.dart';

GoRouter paths(String initialRoute, {MdlClient? cliente, MdlEmploy? empleado}) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/',
        name: 'Inicio',
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: '/manager',
        name: 'Gerente',
        builder: (context, state) => StartView(),
      ),
      GoRoute(
        path: '/client',
        name: 'Cliente',
        builder: (context, state) => ClientView(),
      ),
    ],
  );
}
