import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/atom/textfieldscontroller.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmployLog extends StatelessWidget {
  const EmployLog({super.key});

  @override
  Widget build(BuildContext context) {
    final employCtrl = Get.put(EmployLogController());

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Acceso Empleado',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: employCtrl.cont_User,
            decoration: InputDecoration(
              labelText: 'Usuario',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: employCtrl.cont_Password,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: UnderlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final user = employCtrl.cont_User.text.trim();
                final password = employCtrl.cont_Password.text.trim();

                if (user.isEmpty || password.isEmpty) {
                  WarningSnackbar.show(
                    context,
                    'Por favor completar todos los campos.',
                  );
                  return;
                }

                try {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Empleados')
                      .where('User', isEqualTo: user)
                      .limit(1)
                      .get();

                  if (snapshot.docs.isEmpty) {
                    WarningSnackbar.show(context, 'Usuario no encontrado.');
                    return;
                  }

                  final data = snapshot.docs.first.data();
                  if (data['Password'] == password) {
                    context.go('/manager');
                  } else {
                    ErrorSnackbar.show(context, 'Contraseña incorrecta.');
                  }
                } catch (e) {
                  CriticalErrorSnackbar.show(
                    context,
                    'Error al conectar con el servidor.',
                  );
                  print('Login error: $e');
                }
              }, // vacío por ahora
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Ingresar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
