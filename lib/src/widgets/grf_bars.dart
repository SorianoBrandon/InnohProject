import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GrfBars extends StatelessWidget {
  final List<BarChartGroupData> datos;
  final List<String> marcas;
  final String emitidoPor;
  final String subtitulo;
  final String descripcion;
  final String titulo;

  const GrfBars({
    super.key,
    required this.datos,
    required this.marcas,
    required this.emitidoPor,
    required this.subtitulo,
    required this.descripcion,
    this.titulo = 'Garantías por Marca',
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        // 👈 scroll vertical para todo el widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo y encabezado
            Row(
              children: [
                Flexible(
                  flex: 0,
                  child: Image.asset(
                    'assets/Logo.jpg',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitulo,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Gráfico de barras con scroll horizontal
            SizedBox(
              height: 320,
              child: datos.isEmpty
                  ? const Center(
                      child: Text(
                        "Sin datos para mostrar",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // 👈 scroll horizontal
                      child: SizedBox(
                        width:
                            datos.length *
                            80, // ancho dinámico según cantidad de barras
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipPadding: const EdgeInsets.all(8),
                                tooltipMargin: 8,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                      final porcentaje = rod.toY.isFinite
                                          ? rod.toY.toStringAsFixed(0)
                                          : "0";
                                      return BarTooltipItem(
                                        '$porcentaje%',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 10,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < marcas.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          marcas[index],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: datos,
                          ),
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // Información adicional
            Text(
              'Emitido por: $emitidoPor',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Text(
              'Fecha de generación: $fecha',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1),

            // Pie de página
            const SizedBox(height: 8),
            Text(
              'Fuente: Sistema Garantías Innovah \n$descripcion',
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const Text(
              'Uso Interno',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
