import 'package:cloud_firestore/cloud_firestore.dart';

//Para la subcoleccion de procesos en garantias
class Proceso {
  final String asunto;
  final Timestamp fechaInicio;
  final int flag;

  Proceso({
    required this.asunto,
    required this.fechaInicio,
    required this.flag,
  });

  Map<String, dynamic> toMap() {
    return {
      'Asunto': asunto,
      'FechaInicio': fechaInicio,//descarto el campo descripcion pq no se podria diferenciar bien quien manda que
      'flag': flag,
    };
  }
}

//para la subcoleccion de mensajes en procesos
class Mensaje {
  final String texto;//mensaje
  final String autor; // quien lo envio :"cliente" o "usuario"
  final Timestamp fecha;//para los tiempos

  Mensaje({
    required this.texto,
    required this.autor,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'autor': autor,
      'fecha': fecha,
    };
  }
}


//pa crear los chats por garantia
Future<void> crearProceso(String idGarantia, Proceso proceso) async {
  await FirebaseFirestore.instance
    .collection('Garantias')
    .doc(idGarantia)
    .collection('Procesos')
    .add(proceso.toMap());
}
//leer los procesos de una garantia
Stream<QuerySnapshot> obtenerProcesos(String idGarantia) {
  return FirebaseFirestore.instance
    .collection('Garantias')
    .doc(idGarantia)
    .collection('Procesos')
    .orderBy('FechaInicio', descending: true)
    .snapshots();
}

//agregar mensajes a la garantia
Future<void> agregarMensaje(String idGarantia, String idProceso, Mensaje mensaje) async {
  await FirebaseFirestore.instance
    .collection('Garantias')
    .doc(idGarantia)
    .collection('Procesos')
    .doc(idProceso)
    .collection('Mensajes')
    .add(mensaje.toMap());
}

//leer los mensajes de una garantia por orden de tiempo 
 Stream<QuerySnapshot> obtenerMensajes(String idGarantia, String idProceso) {
  return FirebaseFirestore.instance
    .collection('Garantias')
    .doc(idGarantia)
    .collection('Procesos')
    .doc(idProceso)
    .collection('Mensajes')
    .orderBy('Fecha', descending: false)
    .snapshots();
}
