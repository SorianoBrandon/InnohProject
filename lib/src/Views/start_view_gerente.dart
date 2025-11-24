import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/filtromesMarca.dart';
import 'package:innohproject/src/Views/modal/filtromesMarcas.dart';
import 'package:innohproject/src/Views/modal/filtromesTipo.dart';
import 'package:innohproject/src/atom/tap_Effect.dart';
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
                child: SingleChildScrollView(
                  child: WarrantyList(
                    onSelect: (g, id) {
                      controller.seleccionarGarantia(g, id);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Gráficas abajo como cards pequeñas
              // Gráficas abajo ocupando todo el espacio disponible
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: TapEffect(
                        child: graphicCard(
                          context: context,
                          title: 'Fallas de Productos Entre Marcas',
                          chartId: 1,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) => const FiltroGarantiasModal(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TapEffect(
                        child: graphicCard(
                          context: context,
                          title: 'Falla Productos de una Marca Especifica',
                          chartId: 2,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) =>
                                const FiltroGarantiasPorMarcaModal(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TapEffect(
                        child: graphicCard(
                          context: context,
                          title: 'Falla Tipo de Producto Entre Marcas',
                          chartId: 3,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) =>
                                const FiltroGarantiasPorTipoModal(),
                          );
                        },
                      ),
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
