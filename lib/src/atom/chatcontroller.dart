import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // id del proceso activo
  var procesoId = ''.obs;

  void setProcesoId(String id) {
    procesoId.value = id;
  }

  Future<void> enviarMensaje(String warrantyId) async {
    if (textController.text.trim().isEmpty || procesoId.value.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('Garantias')
        .doc(warrantyId)
        .collection('Procesos')
        .doc(procesoId.value)
        .collection('Mensajes')
        .add({
      'Fecha': Timestamp.now(),
      'Texto': textController.text.trim(),
      'Usuario': 'Cliente',
    });

    textController.clear();
    // opcional: mover scroll al final
    await Future.delayed(const Duration(milliseconds: 300));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
