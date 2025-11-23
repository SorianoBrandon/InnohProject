import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/vendedorcontroller.dart';
import 'package:innohproject/src/env/env_colors.dart';

class StartViewVendedor extends StatelessWidget {
  const StartViewVendedor({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendedorController());

    return Row(
      children: [
        //  Lado izquierdo: listado de garantías
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
                      "Garantías Registradas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // simulado
                  itemBuilder: (context, index) {
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
                        title: Text("Cliente $index"),
                        subtitle: const Text(
                          "DNI: 00000000\nProducto: Demo\nFecha: xx/xx/xxxx",
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // 📌 Lado derecho: formulario
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
                            onChanged: (val) =>
                                controller.codigoProducto.value = val,
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
                          onPressed: controller.buscarProducto,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildReadOnlyField(
                        "Nombre del Producto",
                        controller.nombreProducto.value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildReadOnlyField(
                        "Tiempo Garantía",
                        controller.tiempoGarantia.value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildEditableField(
                        "Número de Serie",
                        controller.numeroSerie,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildEditableField(
                        "Número de Factura",
                        controller.numeroFactura,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildCard(
                  icon: Icons.person,
                  title: "Datos del Cliente",
                  children: [
                    Obx(
                      () => _buildEditableField(
                        "Identidad Cliente",
                        controller.identidadCliente,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildEditableField(
                        "Teléfono",
                        controller.telefonoCliente,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildEditableField(
                        "Nombre Completo",
                        controller.nombreCliente,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _buildEditableField(
                        "Dirección Cliente",
                        controller.direccionCliente,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.guardarVenta,
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar Venta"),
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

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, RxString value) {
    return TextFormField(
      initialValue: value.value,
      onChanged: (val) => value.value = val,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
