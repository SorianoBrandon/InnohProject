
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/vendedorcontroller.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/env/env_colors.dart';

class StartViewVendedor extends StatelessWidget {
   StartViewVendedor({super.key});
  final controllerw = Get.put(WarrantyListController());
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendedorController());
    controllerw.listaGarUser();

    return Row(
      children: [
        // Lado izquierdo: listado de garantías
        Expanded(
  flex: 2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.assignment_turned_in, color: EnvColors.verdete),
            const SizedBox(width: 8),
            const Text(
              "Ventas Registradas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Obx(() {
                  if (controllerw.listaGarantias.isEmpty) {
                    return const Center(child: Text("No hay garantías registradas"));
                  }

                  return ListView.builder(
                    itemCount: controllerw.listaGarantias.length,
                    itemBuilder: (context, index) {
                      final garantia = controllerw.listaGarantias[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.shopping_cart,
                            color: EnvColors.verdete,
                          ),
                          title: Text(garantia.nombreCl),
                          subtitle: Text(
                            "DNI: ${garantia.dni}\n"
                            "Producto: ${garantia.nombrePr}\n"
                            "Fecha: ${garantia.fechaEntrada.day}/${garantia.fechaEntrada.month}/${garantia.fechaEntrada.year}",
                          ),
                          trailing: garantia.estado == 0 ?   Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ):Icon(
                            Icons.stop_circle,
                            color: Colors.red,
                        ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
      ),
    Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCard(
                  icon: Icons.shopping_cart,
                  title: "Datos del Producto",
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.contCodigoProducto,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // 👈 solo números
                              LengthLimitingTextInputFormatter(6),    // 👈 máximo 6 dígitos
                            ],
                            decoration: const InputDecoration(
                              labelText: "Código del Producto",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.search, color: EnvColors.verdete),
                          onPressed:()=> controller.buscarProducto(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.contNombreProducto,
                      enabled: false,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Nombre del Producto",
                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.contTiempoGarantia,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Tiempo Garantía",
                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.contNumeroSerie,
                      decoration: const InputDecoration(
                        labelText: "Número de Serie",
                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.contNumeroFactura,
                      decoration: const InputDecoration(
                        labelText: "Número de Factura",
                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildCard(
                  icon: Icons.person,
                  title: "Datos del Cliente",
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.contIdentidadCliente,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // solo números
                            LengthLimitingTextInputFormatter(13),   // máximo 13 dígitos
                            ],
                            decoration: const InputDecoration(
                              labelText: "Identidad Cliente",
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.search, color: EnvColors.verdete),
                          onPressed: () => controller.buscarCliente(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => TextField(
                    controller: controller.contTelefonoCliente,
                    enabled: controller.isSearchingCliente.value, // editable solo si confirmas agregar
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                    ),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.contNombreCliente,
                    enabled: controller.isSearchingCliente.value,
                    decoration: const InputDecoration(
                      labelText: "Nombres",
                      border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                    ),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.contApellidoCliente,
                    enabled: controller.isSearchingCliente.value,
                    decoration: const InputDecoration(
                      labelText: "Apellidos",
                      border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                    ),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.contDireccionCliente,
                    enabled: controller.isSearchingCliente.value,
                    decoration: const InputDecoration(
                      labelText: "Dirección Cliente",
                      border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)), // 👈 redondeado
                            ),
                    ),
                  )),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed:()=> controller.guardarGarantia(context),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Guardar Garantía",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EnvColors.verdete,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
    ],  
    );
  }

  // 🔹 Card reutilizable
  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: EnvColors.verdete),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
