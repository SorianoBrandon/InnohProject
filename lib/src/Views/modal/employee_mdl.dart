import 'package:flutter/material.dart';
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
    controller.ListaEmploy(); // carga inicial

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Empleados"),
        backgroundColor: EnvColors.azulote,
      ),
      body: Obx(() {
        if (controller.empleados.isEmpty) {
          return const Center(child: Text("No hay empleados registrados"));
        }
        return ListView.builder(
          itemCount: controller.empleados.length,
          itemBuilder: (context, index) {
            final empleado = controller.empleados[index];
            return Card(
              child: ListTile(
                title: Text(empleado.name),
                subtitle: Text(
                  'Usuario: ${empleado.user} - Cel: ${empleado.phone}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        controller.cont_name.text = empleado.name;
                        controller.cont_user.text = empleado.user;
                        controller.cont_password.text = empleado.password;
                        controller.cont_phone.text = empleado.phone;
                        controller.cont_role.text = empleado.role;
                        controller.cont_dni.text = empleado.dni;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => _EmployeeForm(
                            onSave: () {
                              final updated = MdlEmploy(
                                dni: controller.cont_dni.text.trim(),
                                name: controller.cont_name.text.trim(),
                                password: controller.cont_password.text.trim(),
                                phone: controller.cont_phone.text.trim(),
                                role: controller.cont_role.text.trim(),
                                user: controller.cont_user.text.trim(),
                                flag: empleado.flag,
                              );
                              controller.guardarEmpleado(updated, context);
                              controller.ListaEmploy(); // refresca lista
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ConfirmActionDialog.show(
                          context: context,
                          message:
                              "¿Seguro que deseas eliminar a ${empleado.name}?",
                          onConfirm: () {
                            controller.eliminarEmpleado(
                              empleado.dni,
                              context,
                            ); // marca como eliminado
                          },
                          onDenied: () {
                            null;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: EnvColors.verdete,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          controller.limpiarCampos();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _EmployeeForm(
              onSave: () {
                final nuevo = MdlEmploy(
                  dni: controller.cont_dni.text.trim(),
                  name: controller.cont_name.text.trim(),
                  password: controller.cont_password.text.trim(),
                  phone: controller.cont_phone.text.trim(),
                  role: controller.cont_role.text.trim(),
                  user: controller.cont_user.text.trim(),
                );
                controller.guardarEmpleado(nuevo, context);
                controller.ListaEmploy(); // refresca lista
              },
            ),
          );
        },
      ),
    );
  }
}

// Formulario reutilizable
class _EmployeeForm extends StatelessWidget {
  final VoidCallback onSave;
  const _EmployeeForm({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Employcontroller>();
    const Color verde = Color(0xFF28a133);

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller.cont_dni,
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
              decoration: const InputDecoration(
                labelText: 'Celular',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.cont_role,
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onSave();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
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
