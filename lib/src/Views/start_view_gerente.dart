import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/widgets/chatbox.dart';
import 'package:innohproject/src/widgets/graphicscard.dart';
import 'package:innohproject/src/widgets/warrantylist.dart';

class StartViewGerente extends StatelessWidget {
  const StartViewGerente({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WarrantyListController());
    controller.listaGarProceso();

    return Row(
      children: [
        // Sección izquierda
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Garantías arriba con scroll
              Expanded(
                flex: 2,
                child: SingleChildScrollView(child: WarrantyList()),
              ),

              const SizedBox(height: 16),

              // Gráficas abajo como cards pequeñas
              Expanded(
                flex: 1,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    graphicCard(
                      context: context,
                      title: 'Porcentaje de Fallas Entre Marcas',
                      chartId: 1,
                    ),
                    graphicCard(
                      context: context,
                      title: 'Fallas Productos de Marca',
                      chartId: 2,
                    ),
                    graphicCard(
                      context: context,
                      title: 'Falla Producto Entre Tipos',
                      chartId: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Columna derecha faltaria meter el chat de parte del gerente
        Expanded(
          flex: 1,
          child: Obx(() {
            final selected = controller.garantiaSeleccionada.value;
            if (selected == null) {
              return const Center(
                child: Text("Selecciona una garantía para ver el chat"),
              );
            }
            return ChatBox(
              garantia: selected,
              garantiaId: controller.garantiaId.value!,
            );
          }),
        ),
      ],
    );
  }
}
