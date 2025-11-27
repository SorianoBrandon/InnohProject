import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/employcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_employ.dart';

class EmployeeMdl extends StatelessWidget {
  const EmployeeMdl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Employcontroller>();

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
              'Información del Empleado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: controller.cont_dni,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
              decoration: const InputDecoration(
                labelText: 'DNI',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: controller.cont_name,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: controller.cont_user,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: controller.cont_password,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: controller.cont_phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: const InputDecoration(
                labelText: 'Celular',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validar que los campos estén llenos
                  if (controller.cont_dni.text.trim().isEmpty ||
                      controller.cont_name.text.trim().isEmpty ||
                      controller.cont_user.text.trim().isEmpty ||
                      controller.cont_password.text.trim().isEmpty ||
                      controller.cont_phone.text.trim().isEmpty) {
                    ErrorSnackbar.show(
                      context,
                      "Debe completar todos los campos antes de guardar.",
                    );
                    return;
                  }

                  final empleado = MdlEmploy(
                    dni: controller.cont_dni.text.trim(),
                    name: controller.cont_name.text.trim(),
                    user: controller.cont_user.text.trim(),
                    password: controller.cont_password.text.trim(),
                    phone: controller.cont_phone.text.trim(),
                    role: "Vendedor", // siempre será vendedor
                  );

                  controller.guardarEmpleado(empleado, context);
                  SuccessSnackbar.show(
                    context,
                    "Empleado Guardado Correctamente",
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EnvColors.verdete,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
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
