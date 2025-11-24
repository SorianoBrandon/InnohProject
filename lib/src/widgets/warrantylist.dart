import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/custom/report%20generators/reimpresion_report.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';
import 'package:printing/printing.dart';

class WarrantyList extends StatelessWidget {
  final void Function(Warranty, String)? onSelect;

  WarrantyList({super.key, this.onSelect});
  final controller = Get.find<WarrantyListController>();
  final esGerente = CurrentLog.employ != null;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.listaGarantias.isEmpty) {
        return const Center(child: Text('No hay garantías registradas'));
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.listaGarantias.length,
        itemBuilder: (context, index) {
          final g = controller.listaGarantias[index]; // ✅ acceso directo

          return InkWell(
            onTap: () {
              onSelect?.call(g, g.dni + g.ns);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con icono y título
                  ListTile(
                    leading: Icon(Icons.inventory, color: EnvColors.verdete),
                    title: Text(
                      g.nombrePr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: esGerente
                        ? Text(
                            "Cliente: ${g.nombreCl}\nTel: ${g.telefonoCl}\nDNI: ${g.dni}",
                          )
                        : Text(
                            "Inicio: ${g.fechaEntrada.toLocal().toString().split(' ')[0]}\n"
                            "Vence: ${g.fechaVencimiento.toLocal().toString().split(' ')[0]}\n"
                            "Estado: ${g.estado == 1 ? "En proceso" : "Sin iniciar"}",
                          ),
                    trailing: esGerente
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),

                  // Footer con acciones
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: EnvColors.azulote.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Botón iniciar/finalizar (para empleados)
                        if (!esGerente)
                          Column(
                            children: [
                              TextButton.icon(
                                label: Text(
                                  g.estado == 1 ? "Finalizar" : "Iniciar",
                                ),
                                icon: Icon(
                                  g.estado == 1
                                      ? Icons.stop_circle
                                      : Icons.play_circle,
                                  color: g.estado == 1
                                      ? Colors.red
                                      : Colors.green,
                                  size: 25,
                                ),
                                onPressed: () {
                                  g.estado == 1
                                      ? ConfirmActionDialog.show(
                                          context: context,
                                          message:
                                              "¿Desea finalizar el proceso de garantía?",
                                          onConfirm: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Garantias')
                                                .doc(g.dni + g.ns)
                                                .update({
                                                  'Estado': g.estado == 0
                                                      ? 1
                                                      : 0,
                                                });
                                          },
                                          onDenied: () {
                                            null;
                                          },
                                        )
                                      : ConfirmActionDialog.show(
                                          context: context,
                                          message:
                                              "¿Desea iniciar el proceso de garantía?",
                                          onConfirm: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Garantias')
                                                .doc(g.dni + g.ns)
                                                .update({
                                                  'Estado': g.estado == 0
                                                      ? 1
                                                      : 0,
                                                });
                                          },
                                          onDenied: () {
                                            null;
                                          },
                                        );
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                g.estado == 1
                                    ? "Finalizar Proceso Garantia"
                                    : "Iniciar Proceso Garantia",
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                        // Botón de imprimir (todos)
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.orange,
                                size: 28,
                              ),
                              onPressed: () async {
                                try {
                                  final pdf =
                                      await ReportGarantiaReimpresion.build(
                                        garantiaId: g.dni + g.ns,
                                      );
                                  await Printing.layoutPdf(
                                    onLayout: (format) async => pdf.save(),
                                  );
                                } catch (e) {
                                  ErrorSnackbar.show(
                                    context,
                                    "Error al generar la hoja de garantía: $e",
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Imp Hoja Garantia",
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        // Botón de cerrar reclamo (solo gerente)
                        if (esGerente)
                          Column(
                            children: [
                              TextButton.icon(
                                label: const Text("Finalizar Reclamo"),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  ConfirmActionDialog.show(
                                    context: context,
                                    message:
                                        "¿Desea dar por finalizada la conversación de reclamo?",
                                    onConfirm: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('Garantias')
                                            .doc(g.dni + g.ns)
                                            .update({
                                              'Estado': 0,
                                              'NumIncidente':
                                                  (g.numIncidente) + 1,
                                            });

                                        controller.listaGarantias.removeWhere(
                                          (gar) =>
                                              gar.dni + gar.ns == g.dni + g.ns,
                                        );
                                        controller.listaGarantias.refresh();
                                        Navigator.pop(context);
                                      } catch (e) {
                                        ErrorSnackbar.show(
                                          context,
                                          "Error al finalizar garantía: $e",
                                        );
                                      }
                                    },
                                    onDenied: () {
                                      null;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Finalizar Reclamo",
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
