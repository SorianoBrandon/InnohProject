// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_type.dart';

class TypeController extends GetxController {
  final cont_type = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<int> guardarTipo(MdlType type) async {
    final docRef = db.collection('TipoProducto').doc(type.type);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Ya existe una marca con ese nombre
      return 1;
    }

    await docRef.set(type.toJson(), SetOptions(merge: true));
    limpiarCampos();
    return 0;
  }

  void limpiarCampos() {
    cont_type.clear();
  }
}
