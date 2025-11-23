import 'package:cloud_firestore/cloud_firestore.dart';

class Warranty {
  final String codigoProducto;
  final String dni;
  final String ns;
  final String nFactura;
  final int numIncidente;
  final DateTime fechaVencimiento;
  final int estado;
  final String infoUser;
  String? docId; // campo adicional para el id del documento que no resulto muy bien
  String? tituloProducto; // campo adicional para el titulo del producto 
  String? descripcionProducto;

  Warranty({
    required this.codigoProducto,
    required this.dni,
    required this.ns,
    required this.nFactura,
    required this.numIncidente,
    required this.fechaVencimiento,
    required this.estado,
    required this.infoUser,
    this.descripcionProducto,
    this.docId,
    this.tituloProducto,
  });


  factory Warranty.fromJson(Map<String, dynamic> json) {
    return Warranty(
      codigoProducto: json['CodigoProducto'] ?? '',
      dni: json['DNI'] ?? '',
      ns: json['NS'] ?? '',
      nFactura: json['NFactura'] ?? '',
      numIncidente: (json['NumInsidente'] is int)
        ? json['NumInsidente']
        : int.tryParse(json['NumInsidente'].toString()) ?? 0,
      fechaVencimiento: (json['FechaVencimiento'] as Timestamp).toDate(), //asi mero se trabaja las fechas de firebase a flutter
     estado: (json['Estado'] is int)
        ? json['Estado']
        : int.tryParse(json['Estado'].toString()) ?? 0,
      infoUser: json['InfoUser'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodigoProducto': codigoProducto,
      'DNI': dni,
      'NS': ns,
      'NFactura': nFactura,
      'NumInsidente': numIncidente,
      'FechaVencimiento': Timestamp.fromDate(fechaVencimiento),
      'Estado': estado,
      'InfoUser': infoUser,
    };
  }
}
