import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';
import 'package:innohproject/src/widgets/warrantylist.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WarrantyListController());

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
                    dniCliente: CurrentLog.client!.dni,
                    onSelect: (g) {
                      mostrarConfirmacion(context, g);
                    },
                  ),
                ),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el diálogo de confirmación
  void mostrarConfirmacion(BuildContext context, Warranty g) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("¿Iniciar proceso de garantía?"),
        content: const Text("¿Desea iniciar un proceso con esta garantía?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // No
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Sí
              Get.find<WarrantyListController>().seleccionarGarantia(g);
            },
            child: const Text("Sí"),
          ),
        ],
      ),
    );
  }
}
