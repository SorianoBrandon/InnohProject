import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
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
        title: const Center(
          child: Text(
            "Portal de Garantías Innovah",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset('assets/CasaBlanca.png', width: 80, height: 80),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Bienvenido ${CurrentLog.client!.name} ${CurrentLog.client!.lname}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Sus garantías vigentes:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Lista + Chat
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: WarrantyList(
                    onSelect: (g, id) {
                      Get.find<WarrantyListController>().seleccionarGarantia(
                        g,
                        id,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    final selected = controller.garantiaSeleccionada.value;
                    final selectedId = controller.garantiaId.value;
                    if (selected == null || selectedId == null) {
                      return const Center(
                        child: Text(
                          "Seleccione una garantía para iniciar el chat",
                        ),
                      );
                    }
                    return ChatBox(garantia: selected, garantiaId: selectedId);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el diálogo de confirmación
}
