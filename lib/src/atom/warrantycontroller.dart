import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//no me preguntes ni madres de esto,nomas me canse de escribir la garantias a mano
class Warrantycontroller extends GetxController {
  // Estados
  var saving = false.obs;
  var fechaVenc = Rxn<DateTime>();
  var estado = 0.obs;
  var mensaje = ''.obs;

  // Text controllers
  final contCodigoProducto = TextEditingController();
  final contDNI = TextEditingController();
  final contNS = TextEditingController();
  final contNFactura = TextEditingController();
  final contNumIncidente = TextEditingController(text: '0');

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onClose() {
    contCodigoProducto.dispose();
    contDNI.dispose();
    contNS.dispose();
    contNFactura.dispose();
    contNumIncidente.dispose();
    super.onClose();
  }

  void setFechaVenc(DateTime d) => fechaVenc.value = d;
  void setEstado(int v) => estado.value = v;

  Future<void> guardarGarantia({required String infoUser}) async {
    final codigoProducto = contCodigoProducto.text.trim();
    final dni = contDNI.text.trim();
    final ns = contNS.text.trim();
    final nFactura = contNFactura.text.trim();
    final numIncidente = int.tryParse(contNumIncidente.text.trim()) ?? 0;
    final fecha = fechaVenc.value;

    // Validaciones básicas
    if (dni.isEmpty || ns.isEmpty) {
      mensaje.value = 'DNI y NS son obligatorios';
      return;
    }
    if (fecha == null) {
      mensaje.value = 'Selecciona Fecha de Vencimiento';
      return;
    }

    saving.value = true;
    mensaje.value = '';

    try {
      final docId = '${dni}${ns}';
      final docRef = db.collection('Garantias').doc(docId);

      final data = {
        'CodigoProducto': codigoProducto,
        'DNI': dni,
        'Estado': estado.value,
        'FechaVencimiento': Timestamp.fromDate(fecha),
        'InfoUser': infoUser,
        'NFactura': nFactura,
        'NS': ns,
        'NumInsidente': numIncidente,
      };

      final existing = await docRef.get();
      if (existing.exists) {
        await docRef.set(data, SetOptions(merge: true));
        mensaje.value = 'Garantía actualizada';
      } else {
        await docRef.set(data);
        mensaje.value = 'Garantía creada';
      }
    } catch (e) {
      mensaje.value = 'Error: $e';
    } finally {
      saving.value = false;
    }
  }

  void limpiar() {
    contCodigoProducto.clear();
    contDNI.clear();
    contNS.clear();
    contNFactura.clear();
    contNumIncidente.text = '0';
    fechaVenc.value = null;
    estado.value = 0;
    mensaje.value = '';
  }

  DateTime sumarMeses(DateTime fecha, int meses) {
    int nuevoAnio = fecha.year;
    int nuevoMes = fecha.month + meses;

    nuevoAnio += (nuevoMes - 1) ~/ 12;
    nuevoMes = ((nuevoMes - 1) % 12) + 1;

    int ultimoDiaMes = DateTime(nuevoAnio, nuevoMes + 1, 0).day;
    int nuevoDia = fecha.day <= ultimoDiaMes ? fecha.day : ultimoDiaMes;

    return DateTime(nuevoAnio, nuevoMes, nuevoDia);
  }
}
