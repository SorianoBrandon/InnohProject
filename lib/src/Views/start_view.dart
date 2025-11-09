import 'package:flutter/material.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF28a133),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0b3f8e)),
              child: const Center(
                child: Text(
                  'Innovah Comercial',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: () {
                // Aquí puedes abrir ClienteCrud
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Empleados'),
              onTap: () {
                // Aquí puedes abrir EmpleadoCrud
              },
            ),
          ],
        ),
      ),
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
                color: Color(0xFF0b3f8e),
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
