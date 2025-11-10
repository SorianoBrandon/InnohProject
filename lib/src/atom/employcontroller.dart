// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_employ.dart';

class Employcontroller extends GetxController {
  final cont_dni = TextEditingController();
  final cont_role = TextEditingController();
  final cont_name = TextEditingController();
  final cont_password = TextEditingController();
  final cont_user = TextEditingController();
  final cont_phone = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Buscar empleado por DNI haciendo el documento por DNI en firebase
  Future<List<MdlEmploy>> ListaEmploy() async {
    final snapshot = await db
        .collection('Empleados')
        .where('flag', isEqualTo: 1)
        .get();

    empleados.value = snapshot.docs
        .map((doc) => MdlEmploy.fromJson(doc.data()))
        .toList();

    return empleados;
  }

  //Para listar todos los empleados de manera reactiva
  var empleados = <MdlEmploy>[].obs;

  Future<void> guardarEmpleado(MdlEmploy employ, BuildContext context) async {
    //Validacion de campos vacios
    if ([
      employ.dni,
      employ.name,
      employ.password,
      employ.phone,
      employ.role,
      employ.user,
    ].any((campo) => campo.trim().isEmpty)) {
      WarningSnackbar.show(Get.context!, "Todos los campos son obligatorios");
      return;
    }

    try {
      await db
          .collection('Empleados')
          .doc(employ.dni)
          .set(employ.toJson(), SetOptions(merge: true));

      limpiarCampos();
      SuccessSnackbar.show(
        Get.context!,
        "Empleado guardado correctamente",
      ); //pa usarlo
    } catch (e) {
      ErrorSnackbar.show(Get.context!, "Error al guardar: $e");
    }
  }

  //Marcar empleado como eliminado cambiando su bandera a 2
  Future<void> eliminarEmpleado(String dni, BuildContext context) async {
    try {
      await db.collection('Empleados').doc(dni).update({'flag': 2});
      SuccessSnackbar.show(Get.context!, "Empleado marcado como eliminado");
      ListaEmploy(); // refresca la lista
    } catch (e) {
      ErrorSnackbar.show(Get.context!, "Error al eliminar: $e");
    }
  }

  void limpiarCampos() {
    cont_dni.clear();
    cont_phone.clear();
    cont_name.clear();
    cont_role.clear();
    cont_password.clear();
    cont_user.clear();
  }
}
