import 'package:cloud_firestore/cloud_firestore.dart';

class MdlBrand {
  final String brand;
  final Timestamp date;
  final int flag;

  MdlBrand({required this.brand, required this.date, required this.flag});

  Map<String, dynamic> toJson() {
    return {'Brand': brand, 'Fecha': date, 'Flag': flag};
  }

  factory MdlBrand.fromJson(Map<String, dynamic> json) {
    return MdlBrand(
      brand: json['Brand'],
      date: json['Fecha'],
      flag: json['flag'] ?? 1,
    );
  }
}
