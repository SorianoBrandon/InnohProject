// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_brand.dart';

class BrandController extends GetxController {
  final cont_brand = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<int> guardarMarca(MdlBrand brand) async {
    final docRef = db.collection('Marcas').doc(brand.brand);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Ya existe una marca con ese nombre
      return 1;
    }

    await docRef.set(brand.toJson(), SetOptions(merge: true));
    limpiarCampos();
    return 0;
  }

  void limpiarCampos() {
    cont_brand.clear();
  }
}
