import 'package:flutter/material.dart';
import 'package:innohproject/src/custom/custom_drawer.dart';
import 'package:innohproject/src/env/env_Colors.dart';

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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset('assets/CasaBlanca.png', width: 80, height: 80),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 245, 245, 245),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              'Bienvenido al módulo de garantías',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: EnvColors.azulote,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Seleccione una opción en el menú lateral',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
