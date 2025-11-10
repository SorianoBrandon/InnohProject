import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrfPmarcascontroller {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  static List<String> marcas = [];

  /// Retorna el porcentaje de fallos por marca para un tipo de producto específico
  Future<Map<String, double>> calcularPorcentajeFallosPorTipo(
    String tipoFiltrado,
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

    // 4. Crear mapa de código → marca y tipo
    final Map<String, String> mapaCodigoMarca = {};
    final Map<String, String> mapaCodigoTipo = {};

    for (var p in productos) {
      mapaCodigoMarca[p['Codigo']] = p['Marca'];
      mapaCodigoTipo[p['Codigo']] = p['Tipo'];
    }

    // 5. Filtrar garantías cuyo producto sea del tipo especificado
    final garantiasFiltradas = garantias.where((g) {
      final codigo = g['CodigoProducto'];
      return mapaCodigoTipo[codigo] == tipoFiltrado;
    }).toList();

    if (garantiasFiltradas.isEmpty) return {};

    // 6. Contar fallos por marca
    final Map<String, int> conteoPorMarca = {};

    for (var g in garantiasFiltradas) {
      final codigo = g['CodigoProducto'];
      final marca = mapaCodigoMarca[codigo];
      if (marca != null) {
        conteoPorMarca[marca] = (conteoPorMarca[marca] ?? 0) + 1;
      }
    }

    // 7. Calcular porcentajes
    final totalFallos = garantiasFiltradas.length;
    final Map<String, double> porcentajePorMarca = {};

    for (var marca in conteoPorMarca.keys) {
      final porcentaje = (conteoPorMarca[marca]! / totalFallos) * 100;
      porcentajePorMarca[marca] = porcentaje;
    }

    // 8. Guardar marcas en orden
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
