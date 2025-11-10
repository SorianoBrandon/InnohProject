// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_client.dart';

class ClientController extends GetxController {
  var isSearching = false.obs;
  var newclient = false.obs;
  RxString txt_button = 'Guardar'.obs;

  final cont_dni = TextEditingController();
  final cont_phone = TextEditingController();
  final cont_name = TextEditingController();
  final cont_lname = TextEditingController();
  final cont_address = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<int> buscarCliente() async {
    final snapshot = await db
        .collection('Clientes')
        .where('DNI', isEqualTo: cont_dni.text.trim())
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    } else {
      final MdlClient cliente = MdlClient.fromJson(snapshot.docs.first.data());
      cont_phone.text = cliente.phone;
      cont_name.text = cliente.name;
      cont_lname.text = cliente.lname;
      cont_address.text = cliente.address;
      txt_button.value = 'Guardar Cambios';
      isSearching.value = true;
      return 1;
    }
  }

  Future<void> guardarCliente(MdlClient client) async {
    await db
        .collection('Clientes')
        .doc(client.dni)
        .set(client.toJson(), SetOptions(merge: true));
    limpiarCampos();
  }

  void limpiarCampos() {
    isSearching.value = false;
    cont_dni.clear();
    cont_phone.clear();
    cont_name.clear();
    cont_lname.clear();
    cont_address.clear();
  }
}
