import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/brandcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_brand.dart';

class BrandMdl extends StatelessWidget {
  const BrandMdl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandController>();

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
              'Agregar Marca',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.cont_brand,
              decoration: const InputDecoration(
                labelText: 'Marca',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Validar que el campo no esté vacío
                  if (controller.cont_brand.text.trim().isEmpty) {
                    ErrorSnackbar.show(context, "Por favor ingrese una marca.");
                    return; // No continúa si está vacío
                  }

                  final MdlBrand brand = MdlBrand(
                    brand: controller.cont_brand.text.trim(),
                    date: Timestamp.now(),
                    flag: 1,
                  );

                  int estado = await controller.guardarMarca(brand);
                  if (estado == 1) {
                    ErrorSnackbar.show(context, "La Marca ya Existe.");
                  } else {
                    SuccessSnackbar.show(
                      context,
                      'Marca agregada correctamente',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EnvColors.verdete,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Guardar Marca',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
