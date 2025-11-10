import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/modal/client_mdl.dart';
import 'package:innohproject/src/atom/clientcontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

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
      drawer: Drawer(
        backgroundColor: EnvColors.fondo,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 280,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [EnvColors.azulito, EnvColors.azulote],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        child: Text(
                          CurrentLog.employ!.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      CurrentLog.employ!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${CurrentLog.employ!.user}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          CurrentLog.employ!.phone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white70, thickness: 2),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        CurrentLog.employ!.role.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DrawerItem(
              icon: Icons.people_outline_rounded,
              title: "Clientes",
              color: EnvColors.verdete,
              onTap: () {
                context.pop();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    Get.put(ClientController());
                    return ClientMdl();
                  },
                ).then((_) => Get.delete<ClientController>());
              },
            ),
            DrawerItem(
              icon: Icons.work_outline_rounded,
              title: "Empleados",
              color: EnvColors.azulito,
              onTap: () {},
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
