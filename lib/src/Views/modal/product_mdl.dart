import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/productcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_product.dart';

class ProductMdl extends StatefulWidget {
  const ProductMdl({super.key});

  @override
  State<ProductMdl> createState() => _ProductMdlState();
}

class _ProductMdlState extends State<ProductMdl> {
  final controller = Get.find<ProductController>();

  List<String> marcasDisponibles = [];
  List<String> tiposDisponibles = [];
  String? marcaSeleccionada;
  String? tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarMarcas();
    cargarTipos();
  }

  Future<void> cargarMarcas() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Marcas')
        .get();
    setState(() {
      marcasDisponibles = snapshot.docs
          .map((doc) => doc['Brand'] as String)
          .toList();
    });
  }

  Future<void> cargarTipos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('TipoProducto')
        .get();
    setState(() {
      tiposDisponibles = snapshot.docs
          .map((doc) => doc['Tipo'] as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Información del Producto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Código
            TextField(
              controller: controller.cont_codigo,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: "Código",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => controller.buscarProducto(context),
            ),
            const SizedBox(height: 12),

            // Descripción
            TextField(
              controller: controller.cont_descripcion,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Marca (ComboBox)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Marca',
              ),
              value: marcaSeleccionada,
              items: marcasDisponibles.map((m) {
                return DropdownMenuItem(value: m, child: Text(m));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  marcaSeleccionada = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // Modelo
            TextField(
              controller: controller.cont_modelo,
              decoration: const InputDecoration(
                labelText: "Modelo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Tipo (ComboBox)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tipo de Producto',
              ),
              value: tipoSeleccionado,
              items: tiposDisponibles.map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSeleccionado = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // Tiempo de garantía
            TextField(
              controller: controller.cont_tGarantia,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: "Tiempo de garantía (meses)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Botón Guardar
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.cont_codigo.text.trim().isEmpty ||
                        controller.cont_descripcion.text.trim().isEmpty ||
                        controller.cont_modelo.text.trim().isEmpty ||
                        controller.cont_tGarantia.text.trim().isEmpty) {
                      ErrorSnackbar.show(
                        context,
                        "Debe completar todos los campos de texto.",
                      );
                      return;
                    }
                    if (marcaSeleccionada == null || tipoSeleccionado == null) {
                      WarningSnackbar.show(
                        context,
                        "Debe seleccionar Marca y Tipo.",
                      );
                      return;
                    }

                    controller.guardarProducto(
                      Producto(
                        codigo: controller.cont_codigo.text.trim(),
                        descripcion: controller.cont_descripcion.text.trim(),
                        marca: marcaSeleccionada!,
                        modelo: controller.cont_modelo.text.trim(),
                        tipo: tipoSeleccionado!,
                        tGarantia:
                            int.tryParse(
                              controller.cont_tGarantia.text.trim(),
                            ) ??
                            0,
                      ),
                    );
                    SuccessSnackbar.show(
                      context,
                      "Producto guardado correctamente.",
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EnvColors.verdete,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    controller.txt_button.value,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
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
