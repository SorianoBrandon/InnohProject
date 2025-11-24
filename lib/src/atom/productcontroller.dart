// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_product.dart';

class ProductController extends GetxController {
  var isSearching = false.obs;
  var newproduct = false.obs;
  RxString txt_button = 'Guardar'.obs;

  final cont_codigo = TextEditingController();
  final cont_descripcion = TextEditingController();
  final cont_marca = TextEditingController();
  final cont_modelo = TextEditingController();
  final cont_tipo = TextEditingController();
  final cont_tGarantia = TextEditingController(); // en meses

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<int> buscarProducto() async {
    final snapshot = await db
        .collection('Productos')
        .where('Codigo', isEqualTo: cont_codigo.text.trim())
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    } else {
      final Producto producto = Producto.fromJson(snapshot.docs.first.data());
      cont_descripcion.text = producto.descripcion;
      cont_marca.text = producto.marca;
      cont_modelo.text = producto.modelo;
      cont_tipo.text = producto.tipo;
      cont_tGarantia.text = producto.tGarantia.toString();
      txt_button.value = 'Guardar Cambios';
      isSearching.value = true;
      return 1;
    }
  }

  Future<void> guardarProducto(Producto producto) async {
    await db
        .collection('Productos')
        .doc(producto.codigo)
        .set(producto.toJson(), SetOptions(merge: true));
    limpiarCampos();
  }

  void limpiarCampos() {
    isSearching.value = false;
    cont_codigo.clear();
    cont_descripcion.clear();
    cont_marca.clear();
    cont_modelo.clear();
    cont_tipo.clear();
    cont_tGarantia.clear();
  }
}
