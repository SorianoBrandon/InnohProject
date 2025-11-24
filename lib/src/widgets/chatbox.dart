import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/chatcontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/models/mdl_messages.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class ChatBox extends StatelessWidget {
  final Warranty garantia;
  final String garantiaId;

  const ChatBox({super.key, required this.garantia, required this.garantiaId});

  bool isMyMessage(String usuario) {
    final currentUserId = CurrentLog.employ?.role ?? "Cliente";
    return usuario == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    chatController.setWarrantyId(garantiaId);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: EnvColors.verdete,
          child: Text(
            garantia.nombrePr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Lista de mensajes
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Garantias')
                .doc(chatController.warrantyId.value)
                .collection('Mensajes')
                .orderBy('Fecha')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final mensajes = snapshot.data!.docs
                  .map((doc) => MensajeModel.fromDoc(doc))
                  .toList();

              if (mensajes.isEmpty) {
                return const Center(child: Text("No hay mensajes"));
              }

              return ListView.builder(
                controller: chatController.scrollController,
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final msg = mensajes[index];
                  final esMiMensaje = isMyMessage(msg.usuario);

                  return Align(
                    alignment: esMiMensaje
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: esMiMensaje
                            ? EnvColors.verdete
                            : EnvColors.azulito,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.texto,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "${msg.fecha.hour}:${msg.fecha.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Caja de entrada
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatController.textController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu mensaje...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: EnvColors.verdete,
                onPressed: () {
                  chatController.enviarMensaje();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
