import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:flutter/material.dart';

class LoginAuth {
  Future<int> Loging(
    BuildContext context,
    String identity,
    String? password,
  ) async {
    // ignore: type_check_with_null
    if (password is Null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Clientes')
            .where('DNI', isEqualTo: identity)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          ErrorSnackbar.show(context, 'Cliente no encontrado.');
          return 0;
        } else {
          CurrentLog.loadLog(cliente: snapshot);
          return 1;
        }
      } catch (e) {
        CriticalErrorSnackbar.show(
          context,
          'Error al conectar con el servidor.',
        );
        print('Login error: $e');
      }
    } else {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Empleados')
            .where('User', isEqualTo: identity)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          WarningSnackbar.show(context, 'Usuario no encontrado.');
          return 0;
        }

        final data = snapshot.docs.first.data();
        if (data['Password'] == password) {
          CurrentLog.loadLog(empleado: snapshot);
          CurrentLog.islog = true;
          return 1;
        } else {
          ErrorSnackbar.show(context, 'Contraseña incorrecta.');
          return 0;
        }
      } catch (e) {
        CriticalErrorSnackbar.show(
          context,
          'Error al conectar con el servidor.',
        );
        print('Login error: $e');
      }
    }
    return 0;
  }
}
