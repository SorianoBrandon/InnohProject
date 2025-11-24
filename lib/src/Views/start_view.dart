import 'package:flutter/material.dart';
import 'package:innohproject/src/custom/custom_drawer.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/Views/start_view_vendedor.dart';
import 'package:innohproject/src/Views/start_view_gerente.dart';
import 'package:innohproject/src/Views/client_view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EnvColors.verdete,
        automaticallyImplyLeading: true,
        title: const Text(
          'Garantías Innovah Comercial',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset('assets/CasaBlanca.png', width: 80, height: 80),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: CurrentLog.employ!.role == 'Vendedor'
          ? StartViewVendedor()
          : CurrentLog.employ!.role == 'Gerente'
          ? StartViewGerente()
          : ClientView(),
    );
  }
}
