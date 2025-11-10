import 'package:flutter/material.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/helpers/sesionhelper.dart';
import 'package:innohproject/src/models/mdl_client.dart';
import 'package:innohproject/src/models/mdl_employ.dart' show MdlEmploy;
import 'package:innohproject/src/paths/paths.dart';
import 'package:innohproject/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final metodo = await SesionHelper.leerMetodo();

  if (metodo == 'cliente') {
    final cliente = await SesionHelper.leerCliente();
    CurrentLog.client = cliente;
    runApp(MyApp(initialRoute: '/client', cliente: cliente));
  } else if (metodo == 'empleado') {
    final empleado = await SesionHelper.leerEmpleado();
    CurrentLog.employ = empleado;
    runApp(MyApp(initialRoute: '/manager', empleado: empleado));
  } else {
    runApp(const MyApp(initialRoute: '/'));
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final MdlClient? cliente;
  final MdlEmploy? empleado;

  const MyApp({
    super.key,
    required this.initialRoute,
    this.cliente,
    this.empleado,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Innovah Creditos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 58),
        ),
      ),
      routerConfig: paths(initialRoute, cliente: cliente, empleado: empleado),
    );
  }
}
