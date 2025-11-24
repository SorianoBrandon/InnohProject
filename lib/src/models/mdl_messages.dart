import 'package:cloud_firestore/cloud_firestore.dart';

class MensajeModel {
  final String id; 
  final String texto;
  final String usuario;
  final DateTime fecha;

  MensajeModel({
    this.id = '',
    required this.texto,
    required this.usuario,
    required this.fecha,
  });

  Map<String, dynamic> toMap() => {
        'Texto': texto,
        'Usuario': usuario,
        'Fecha': fecha,
      };

  factory MensajeModel.fromDoc(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>?; 
  if (data == null) {
    return MensajeModel(
      id: doc.id,
      texto: '',
      usuario: '',
      fecha: DateTime.now(),
    );
  }

  return MensajeModel(
    id: doc.id,
    texto: data['Texto'] ?? '',
    usuario: data['Usuario'] ?? '',
    fecha: (data['Fecha'] is Timestamp)
        ? (data['Fecha'] as Timestamp).toDate()
        : DateTime.now(),
  );
}
}
