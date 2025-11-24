import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class GrfMproductoscontroller {
  static List<String> tipos = [];

  /// Calcula el porcentaje de fallos por tipo de producto dentro de una marca específica
  Future<Map<String, double>> calcularPorcentajeFallosPorTipo(
    String marcaFiltrada,
  ) async {
    final controller = Get.find<WarrantyListController>();
    final garantias = controller.listaGgraficas;

    if (garantias.isEmpty) return {};

    // 1. Filtrar garantías de la marca indicada
    final garantiasMarca = garantias
        .where((g) => g.marca == marcaFiltrada)
        .toList();
    if (garantiasMarca.isEmpty) return {};

    // 2. Contar fallos por tipo de producto
    final Map<String, int> conteoPorTipo = {};
    for (var g in garantiasMarca) {
      final tipo = g.tipoP.isNotEmpty ? g.tipoP : 'Desconocido';
      conteoPorTipo[tipo] = (conteoPorTipo[tipo] ?? 0) + 1;
    }

    // 3. Calcular porcentajes
    final totalFallos = garantiasMarca.length;
    final Map<String, double> porcentajePorTipo = {};
    for (var tipo in conteoPorTipo.keys) {
      final porcentaje = (conteoPorTipo[tipo]! / totalFallos) * 100;
      porcentajePorTipo[tipo] = porcentaje;
    }

    tipos = porcentajePorTipo.keys.toList();
    return porcentajePorTipo;
  }

  /// Genera datos para el gráfico de barras por tipo de producto fallado
  Future<List<BarChartGroupData>> generarDatosBarraPorTipo(
    String marcaFiltrada,
  ) async {
    final porcentajes = await calcularPorcentajeFallosPorTipo(marcaFiltrada);
    int index = 0;

    return porcentajes.entries.map((entry) {
      final color = Colors.teal[400 + (index % 4) * 100] ?? Colors.teal;
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
