import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrfMproductoscontroller {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  static List<String> tipos = [];

  /// Retorna el porcentaje de fallos por tipo de producto dentro de una marca específica
  Future<Map<String, double>> calcularPorcentajeFallosPorTipo(
    String marcaFiltrada,
  ) async {
    // 1. Obtener todas las garantías
    final garantiasSnapshot = await db.collection('Garantias').get();
    final garantias = garantiasSnapshot.docs;

    if (garantias.isEmpty) return {};

    // 2. Extraer códigos únicos de producto desde las garantías
    final codigos = garantias.map((g) => g['CodigoProducto']).toSet().toList();

    // 3. Obtener productos relacionados con esos códigos
    final productosSnapshot = await db
        .collection('Productos')
        .where('Codigo', whereIn: codigos)
        .get();

    final productos = productosSnapshot.docs;

    // 4. Crear mapa de código → tipo (solo si la marca coincide)
    final Map<String, String> mapaCodigoTipo = {};
    final Set<String> codigosMarca = {};

    for (var p in productos) {
      if (p['Marca'] == marcaFiltrada) {
        mapaCodigoTipo[p['Codigo']] = p['Tipo'];
        codigosMarca.add(p['Codigo']);
      }
    }

    // 5. Filtrar garantías que correspondan a productos de esa marca
    final garantiasMarca = garantias
        .where((g) => codigosMarca.contains(g['CodigoProducto']))
        .toList();

    if (garantiasMarca.isEmpty) return {};

    // 6. Contar fallos por tipo
    final Map<String, int> conteoPorTipo = {};

    for (var g in garantiasMarca) {
      final codigo = g['CodigoProducto'];
      final tipo = mapaCodigoTipo[codigo];
      if (tipo != null) {
        conteoPorTipo[tipo] = (conteoPorTipo[tipo] ?? 0) + 1;
      }
    }

    // 7. Calcular porcentajes
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
