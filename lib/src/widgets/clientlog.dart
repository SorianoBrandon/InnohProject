import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/atom/textfieldscontroller.dart';
import 'package:innohproject/src/auth/login_auth.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:get/get.dart';

class ClientLog extends StatelessWidget {
  const ClientLog({super.key});

  @override
  Widget build(BuildContext context) {
    final clientCont = Get.put(EmployLogController());
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
            'Reclamos y Garantías',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: clientCont.cont_DNI,
            decoration: InputDecoration(
              labelText: 'Numero de Identidad',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: clientCont.isLoading.value
                    ? null
                    : () async {
                        final dni = clientCont.cont_DNI.text.trim();

                        if (dni.isEmpty) {
                          WarningSnackbar.show(
                            context,
                            "El DNI no puede estar vacío",
                          );
                          return;
                        }
                        clientCont.isLoading.value = true;
                        int log = await LoginAuth().Loging(context, dni, null);
                        clientCont.isLoading.value = false;
                        if (log != 0) {
                          context.go('/client');
                        }
                      },
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
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
