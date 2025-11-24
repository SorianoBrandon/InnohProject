import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class VendedorController extends GetxController {
  final db = FirebaseFirestore.instance;
  String _marcaProducto = "";
  String _tipoProducto = "";

  // Campos del producto
  final contCodigoProducto = TextEditingController();
  final contNombreProducto = TextEditingController();
  final contTiempoGarantia = TextEditingController();

  // Campos manuales
  final contNumeroSerie = TextEditingController();
  final contNumeroFactura = TextEditingController();

  // Datos del cliente
  final contIdentidadCliente = TextEditingController();
  final contTelefonoCliente = TextEditingController();
  final contNombreCliente = TextEditingController();
  final contApellidoCliente = TextEditingController();
  final contDireccionCliente = TextEditingController();

  var isSearchingProducto = false.obs;
  var isSearchingCliente = false.obs;

  
  // Buscar producto por código
  int _tgGarantia = 0;
  Future<void> buscarProducto(BuildContext context) async {
  final codigo = contCodigoProducto.text.trim();

  // Validación: mínimo 4 dígitos
  if (codigo.length < 4) {
    ErrorSnackbar.show(context, "El código debe tener al menos 4 dígitos");
    contNombreProducto.text = "";
    contTiempoGarantia.clear();
    _marcaProducto = "";
    _tipoProducto = "";
    isSearchingProducto.value = true;
    return;
  }

  final snap = await db.collection('Productos').doc(contCodigoProducto.text.trim()).get();

  if (snap.exists) {
    final data = snap.data()!;
    contNombreProducto.text = data['Descripcion'] ?? '';

    _tgGarantia = data['TGarantia'] ?? 0;
    if (_tgGarantia >= 12 && _tgGarantia % 12 == 0) {
      contTiempoGarantia.text = "${_tgGarantia ~/ 12} año(s)";
    } else {
      contTiempoGarantia.text = "$_tgGarantia meses";
    }

    _marcaProducto = data['Marca'] ?? "";
    _tipoProducto = data['Tipo'] ?? "";

    isSearchingProducto.value = false;
  } else {
    ErrorSnackbar.show(context, "El producto no existe en la base de datos");
    contNombreProducto.text = "";
    contTiempoGarantia.clear();
    _marcaProducto = "";
    _tipoProducto = "";
    isSearchingProducto.value = true;
  }
}
  
  Stream<QuerySnapshot<Map<String, dynamic>>> streamGarantias() {
  return db.collection('Garantias').orderBy('fechaEntrada', descending: true).snapshots();
  }

  void limpiarCamposProductos() {
    contCodigoProducto.clear();
    contNombreProducto.clear();
    contTiempoGarantia.clear();
    contNumeroSerie.clear();
    contNumeroFactura.clear();
    isSearchingProducto.value = false;
  }

    void limpiarCamposCliente() {
    contIdentidadCliente.clear();
    contTelefonoCliente.clear();
    contNombreCliente.clear();
    contApellidoCliente.clear();
    contDireccionCliente.clear();
    isSearchingCliente.value = false;
  }
  // Buscar cliente por DNI
  Future<void> buscarCliente(BuildContext context) async {
    if (contIdentidadCliente.text.trim().isEmpty) return;

    final snap = await db
        .collection('Clientes')
        .where('DNI', isEqualTo: contIdentidadCliente.text.trim())
        .get();

    if (snap.docs.isNotEmpty) {
      final data = snap.docs.first.data();
      contTelefonoCliente.text = data['Phone'] ?? '';
      contNombreCliente.text = data['Name'] ?? '';
      contApellidoCliente.text = data['LName'] ?? '';
      contDireccionCliente.text = data['Address'] ?? '';
      isSearchingCliente.value = false;
    } else {
      ConfirmActionDialog.show(
      context: context,
      message: "Cliente no encontrado. ¿Desea agregarlo?",
      onConfirm: () {
        isSearchingCliente.value = true; 
        contTelefonoCliente.clear();
        contNombreCliente.clear();
        contApellidoCliente.clear();
        contDireccionCliente.clear();
      },
      onDenied: () {
        limpiarCamposCliente();
      },
    );    

    }
  }
  
  DateTime calcularFechaVencimiento(DateTime inicio, int meses) {
  int year = inicio.year;
  int month = inicio.month + meses;

  // Normalizar año y mes
  year += (month - 1) ~/ 12;
  month = ((month - 1) % 12) + 1;

  // Ajustar día si no existe en ese mes
  int day = inicio.day;
  int lastDayOfMonth = DateTime(year, month + 1, 0).day;
  if (day > lastDayOfMonth) {
    day = lastDayOfMonth;
  }

  return DateTime(year, month, day);
}

  Future<void> guardarGarantia(BuildContext context) async {
  if (contCodigoProducto.text.trim().isEmpty ||
      contNumeroSerie.text.trim().isEmpty ||
      contNumeroFactura.text.trim().isEmpty ||
      contIdentidadCliente.text.trim().isEmpty) {
    ErrorSnackbar.show(context, "Completa todos los campos obligatorios");
    return;
  }

  if (contNombreProducto.text.trim().isEmpty) {
  ErrorSnackbar.show(context, "Debes buscar el producto antes de guardar la garantía");
  return;
  }
  final fechaEntrada = DateTime.now();
  final fechaVencimiento = calcularFechaVencimiento(fechaEntrada, _tgGarantia);

  // 🔹 Crear garantía
  final garantia = Warranty(
    codigoProducto: contCodigoProducto.text.trim(),
    dni: contIdentidadCliente.text.trim(),
    ns: contNumeroSerie.text.trim(),
    nFactura: contNumeroFactura.text.trim(),
    numIncidente: 0,
    fechaEntrada: fechaEntrada,
    fechaVencimiento: fechaVencimiento,
    estado: 0,
    infoUser: CurrentLog.employ!.user,
    marca: _marcaProducto, 
    nombreCl: contNombreCliente.text.trim(), 
    nombrePr: contNombreProducto.text.trim(),
    telefonoCl: contTelefonoCliente.text.trim(),
    tipoP: _tipoProducto,
  );

  final uniqueId = "${contIdentidadCliente.text.trim()}${contNumeroSerie.text.trim()}";

  await db.collection('Garantias').doc(uniqueId).set(garantia.toJson());


  // 🔹 Guardar cliente si no existe
  final clienteSnap = await db
      .collection('Clientes')
      .where('DNI', isEqualTo: contIdentidadCliente.text.trim())
      .get();

  if (clienteSnap.docs.isEmpty) {
    final uniqueIdC = contIdentidadCliente.text.trim();
    await db.collection('Clientes').doc(uniqueIdC).set({
      'DNI': contIdentidadCliente.text.trim(),
      'Phone': contTelefonoCliente.text.trim(),
      'Name': contNombreCliente.text.trim(),
      'LName': contApellidoCliente.text.trim(),
      'Address': contDireccionCliente.text.trim(),
    });
  }

  SuccessSnackbar.show(context, "La garantía y el cliente se guardaron correctamente");
  limpiarCamposCliente();
  limpiarCamposProductos();
}

  
}
