import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:get/get.dart';

class GrfMarcasController {
  static List<String> marcas = [];

  /// Calcula el porcentaje de garantías por marca usando WarrantyListController
  Future<Map<String, double>> calcularPorcentajePorMarca() async {
    final controller = Get.find<WarrantyListController>();
    final garantias = controller.listaGgraficas;

    if (garantias.isEmpty) return {};

    // 1. Contar garantías por marca directamente
    final Map<String, int> conteoPorMarca = {};
    for (var g in garantias) {
      final marca = g.marca.isNotEmpty ? g.marca : 'Desconocida';
      conteoPorMarca[marca] = (conteoPorMarca[marca] ?? 0) + 1;
    }

    // 2. Calcular porcentajes
    final totalGarantias = garantias.length;
    final Map<String, double> porcentajePorMarca = {};
    for (var marca in conteoPorMarca.keys) {
      final porcentaje = (conteoPorMarca[marca]! / totalGarantias) * 100;
      porcentajePorMarca[marca] = porcentaje;
    }

    marcas = porcentajePorMarca.keys.toList();
    return porcentajePorMarca;
  }

  /// Genera datos para la gráfica de barras
  Future<List<BarChartGroupData>> generarDatosBarra() async {
    final porcentajes = await calcularPorcentajePorMarca();
    int index = 0;

    final lista = porcentajes.entries.map((entry) {
      final color = Colors.blue[index % Colors.primaries.length];
      final grupoData = BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: entry.value, color: color, width: 20)],
        showingTooltipIndicators: [0],
      );
      index++;
      return grupoData;
    }).toList();
    return lista;
  }
}
