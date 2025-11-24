import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/clientcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_client.dart';

class ClientMdl extends StatelessWidget {
  const ClientMdl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientController>();

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Cliente',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Obx(
                  () => Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ],
                      enabled: !controller.isSearching.value,
                      controller: controller.cont_dni,
                      decoration: InputDecoration(
                        labelText: 'Identificación',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => ElevatedButton(
                    onPressed: !controller.isSearching.value
                        ? () async {
                            if (controller.cont_dni.text.trim().isEmpty ||
                                controller.cont_dni.text.length < 13) {
                              WarningSnackbar.show(
                                context,
                                "Debe completar la Identidad del cliente.",
                              );
                              return;
                            }
                            int buscando = await controller.buscarCliente();
                            if (buscando == 0) {
                              ConfirmActionDialog.show(
                                context: context,
                                message:
                                    "Cliente no encontrado. ¿Desea agregarlo?",
                                onConfirm: () {
                                  controller.isSearching.value = true;
                                },
                                onDenied: () {
                                  controller.limpiarCampos();
                                },
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EnvColors.verdete,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, size: 20, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Buscar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => TextField(
                enabled: controller.isSearching.value,
                controller: controller.cont_name,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Obx(
              () => TextField(
                enabled: controller.isSearching.value,
                controller: controller.cont_lname,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Obx(
              () => TextField(
                enabled: controller.isSearching.value,
                controller: controller.cont_phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),

            const SizedBox(height: 12),
            Obx(
              () => TextField(
                enabled: controller.isSearching.value,
                controller: controller.cont_address,
                decoration: const InputDecoration(
                  labelText: 'Dirección Cliente',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSearching.value
                      ? () async {
                          final MdlClient client = MdlClient(
                            dni: controller.cont_dni.text.trim(),
                            name: controller.cont_name.text.trim(),
                            lname: controller.cont_lname.text.trim(),
                            address: controller.cont_address.text.trim(),
                            phone: controller.cont_phone.text.trim(),
                          );
                          controller.guardarCliente(client);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EnvColors.verdete,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    '${controller.txt_button}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
