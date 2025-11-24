import 'package:cloud_firestore/cloud_firestore.dart';

class Warranty {
  final String codigoProducto;
  final String dni;
  final int estado;
  final DateTime fechaEntrada;
  final DateTime fechaVencimiento;
  final String infoUser;
  final String marca;
  final String nFactura;
  final String ns;
  final String nombreCl;
  final String nombrePr;
  final String telefonoCl;
  final int numIncidente;

  Warranty({
    required this.codigoProducto,
    required this.dni,
    required this.ns,
    required this.nFactura,
    required this.numIncidente,
    required this.fechaEntrada,
    required this.fechaVencimiento,
    required this.estado,
    required this.infoUser,
    required this.marca,
    required this.nombreCl,
    required this.nombrePr,
    required this.telefonoCl,
  });

  factory Warranty.fromJson(Map<String, dynamic> json) {
    return Warranty(
      codigoProducto: json['CodigoProducto'] ?? '',
      dni: json['DNI'] ?? '',
      ns: json['NS'] ?? '',
      nFactura: json['NFactura'] ?? '',
      numIncidente: (json['NumIncidente'] is int)
          ? json['NumIncidente']
          : int.tryParse(json['NumIncidente'].toString()) ?? 0,
      fechaEntrada: (json['FechaEntrada'] as Timestamp).toDate(),
      fechaVencimiento: (json['FechaVencimiento'] as Timestamp).toDate(),
      estado: (json['Estado'] is int)
          ? json['Estado']
          : int.tryParse(json['Estado'].toString()) ?? 0,
      infoUser: json['InfoUser'] ?? '',
      marca: json['Marca'] ?? '',
      nombreCl: json['NombreCl'] ?? '',
      nombrePr: json['NombrePr'] ?? '',
      telefonoCl: json['TelefonoCl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodigoProducto': codigoProducto,
      'DNI': dni,
      'NS': ns,
      'NFactura': nFactura,
      'NumIncidente': numIncidente,
      'FechaEntrada': Timestamp.fromDate(fechaEntrada),
      'FechaVencimiento': Timestamp.fromDate(fechaVencimiento),
      'Estado': estado,
      'InfoUser': infoUser,
      'Marca': marca,
      'NombreCl': nombreCl,
      'NombrePr': nombrePr,
      'TelefonoCl': telefonoCl,
    };
  }
}
