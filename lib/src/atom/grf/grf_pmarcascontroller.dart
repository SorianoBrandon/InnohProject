import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class GrfPmarcascontroller {
  static List<String> marcas = [];

  /// Retorna el porcentaje de fallos por marca para un tipo de producto específico
  Future<Map<String, double>> calcularPorcentajeFallosPorTipo(
    String tipoFiltrado,
  ) async {
    final controller = Get.find<WarrantyListController>();
    final garantias = controller.listaGgraficas;

    if (garantias.isEmpty) return {};

    // 1. Filtrar garantías cuyo producto sea del tipo especificado
    final garantiasFiltradas = garantias
        .where((g) => g.tipoP == tipoFiltrado)
        .toList();
    if (garantiasFiltradas.isEmpty) return {};

    // 2. Contar fallos por marca
    final Map<String, int> conteoPorMarca = {};
    for (var g in garantiasFiltradas) {
      final marca = g.marca.isNotEmpty ? g.marca : 'Desconocida';
      conteoPorMarca[marca] = (conteoPorMarca[marca] ?? 0) + 1;
    }

    // 3. Calcular porcentajes
    final totalFallos = garantiasFiltradas.length;
    final Map<String, double> porcentajePorMarca = {};
    for (var marca in conteoPorMarca.keys) {
      final porcentaje = (conteoPorMarca[marca]! / totalFallos) * 100;
      porcentajePorMarca[marca] = porcentaje;
    }

    // 4. Guardar marcas en orden
    marcas = porcentajePorMarca.keys.toList();
    return porcentajePorMarca;
  }

  /// Genera datos para el gráfico de barras por marca (para un tipo de producto)
  Future<List<BarChartGroupData>> generarDatosBarraPorTipo(
    String tipoFiltrado,
  ) async {
    final porcentajes = await calcularPorcentajeFallosPorTipo(tipoFiltrado);
    int index = 0;

    return porcentajes.entries.map((entry) {
      final color = Colors.blue[400 + (index % 4) * 100] ?? Colors.blue;
      final grupo = BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: color,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
      index++;
      return grupo;
    }).toList();
  }
}
