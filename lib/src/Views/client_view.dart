import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/sesionhelper.dart';
import 'package:innohproject/src/widgets/chatbox.dart';
import 'package:innohproject/src/widgets/warrantylist.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class ClientView extends StatelessWidget {
  ClientView({super.key});
  final controller = Get.put(WarrantyListController());

  @override
  Widget build(BuildContext context) {
    controller.listaGarDni(CurrentLog.client!.dni);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: EnvColors.verdete,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            await SesionHelper.borrar();
            context.goNamed('Inicio');
          },
        ),
        title: const Text(
          "Portal de Garantías Innovah",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Image.asset('assets/CasaBlanca.png', width: 60, height: 60),
          ),
        ],
      ),
      body: Row(
        children: [
          // Chat ocupa todo el alto del lado izquierdo
          Expanded(
            flex: 3,
            child: Obx(() {
              final selected = controller.garantiaSeleccionada.value;
              final selectedId = controller.garantiaId.value;
              if (selected == null || selectedId == null) {
                return const Center(
                  child: Text(
                    "Seleccione una garantía para iniciar el chat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                );
              }
              return ChatBox(garantia: selected, garantiaId: selectedId);
            }),
          ),

          // Lista de garantías al lado derecho
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Bienvenido ${CurrentLog.client!.name} ${CurrentLog.client!.lname}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Sus garantías vigentes:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: WarrantyList(
                    onSelect: (g, id) {
                      Get.find<WarrantyListController>().seleccionarGarantia(
                        g,
                        id,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
