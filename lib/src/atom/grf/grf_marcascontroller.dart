import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrfMarcasController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  static List<String> marcas = [];

  /// Retorna un mapa con el porcentaje de garantías por marca
  Future<Map<String, double>> calcularPorcentajePorMarca() async {
    // 1. Obtener todas las garantías
    final garantiasSnapshot = await db.collection('Garantias').get();
    final garantias = garantiasSnapshot.docs;

    if (garantias.isEmpty) return {};

    // 2. Extraer códigos únicos de producto
    final codigos = garantias.map((g) => g['CodigoProducto']).toSet().toList();

    // 3. Obtener productos relacionados
    final productosSnapshot = await db
        .collection('Productos')
        .where('Codigo', whereIn: codigos)
        .get();

    final productos = productosSnapshot.docs;

    // 4. Crear mapa de código → marca
    final Map<String, String> mapaCodigosMarca = {
      for (var p in productos) p['Codigo']: p['Marca'],
    };

    // 5. Contar garantías por marca
    final Map<String, int> conteoPorMarca = {};

    for (var g in garantias) {
      final codigo = g['CodigoProducto'];
      final marca = mapaCodigosMarca[codigo] ?? 'Desconocida';
      conteoPorMarca[marca] = (conteoPorMarca[marca] ?? 0) + 1;
    }

    // 6. Calcular porcentajes
    final totalGarantias = garantias.length;
    final Map<String, double> porcentajePorMarca = {};

    for (var marca in conteoPorMarca.keys) {
      final porcentaje = (conteoPorMarca[marca]! / totalGarantias) * 100;
      porcentajePorMarca[marca] = porcentaje;
    }
    marcas = porcentajePorMarca.keys.toList();
    return porcentajePorMarca;
  }

  Future<List<BarChartGroupData>> generarDatosBarra() async {
    final porcentajes = await calcularPorcentajePorMarca();
    int index = 0;

    return porcentajes.entries.map((entry) {
      final color = Colors.primaries[index % Colors.primaries.length];
      final grupo = BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: entry.value, color: color, width: 20)],
        showingTooltipIndicators: [0],
      );
      index++;
      return grupo;
    }).toList();
  }
}
