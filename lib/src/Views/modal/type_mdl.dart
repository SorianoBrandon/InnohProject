import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/typecontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_type.dart';

class TypeMdl extends StatelessWidget {
  const TypeMdl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TypeController>();

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
              'Agregar Tipo de Producto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.cont_type,
              decoration: const InputDecoration(
                labelText: 'Tipo de Producto',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.cont_type.text.trim().isEmpty) {
                    ErrorSnackbar.show(
                      context,
                      "Debe ingresar un tipo de producto.",
                    );
                    return; // Detiene la ejecución si está vacío
                  }
                  final MdlType type = MdlType(
                    type: controller.cont_type.text.trim(),
                  );
                  int estado = await controller.guardarTipo(type);
                  if (estado == 1) {
                    ErrorSnackbar.show(
                      context,
                      "El tipo de producto ya Existe.",
                    );
                  } else {
                    SuccessSnackbar.show(
                      context,
                      'Tipo de producto agregado correctamente',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EnvColors.verdete,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Guardar',
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
