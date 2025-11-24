import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/models/mdl_messages.dart';

class ChatController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  var warrantyId = ''.obs;

  void setWarrantyId(String id) {
    warrantyId.value = id;
  }

  Future<void> enviarMensaje() async {
    final texto = textController.text.trim();
    final currentRole = CurrentLog.employ?.role ?? "Cliente";

    if (texto.isEmpty || warrantyId.value.isEmpty) return;

    final mensaje = MensajeModel(
      texto: texto,
      usuario: currentRole,
      fecha: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('Garantias')
          .doc(warrantyId.value)
          .collection('Mensajes')
          .add(mensaje.toMap());

      textController.clear();
      await Future.delayed(const Duration(milliseconds: 300));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      Get.snackbar('Error', 'No se pudo enviar el mensaje');
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
