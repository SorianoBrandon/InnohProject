class Producto {
  final String codigo;
  final String descripcion;
  final String marca;
  final String modelo;
  final int tGarantia; // en meses
  final String tipo;

  Producto({
    required this.codigo,
    required this.descripcion,
    required this.marca,
    required this.modelo,
    required this.tGarantia,
    required this.tipo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['Codigo'] ?? '',
      descripcion: json['Descripcion'] ?? '',
      marca: json['Marca'] ?? '',
      modelo: json['Modelo'] ?? '',
      tGarantia: json['TGarantia'] ?? 0,
      tipo: json['Tipo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Codigo': codigo,
      'Descripcion': descripcion,
      'Marca': marca,
      'Modelo': modelo,
      'TGarantia': tGarantia,
      'Tipo': tipo,
    };
  }
}
