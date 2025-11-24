import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:innohproject/src/widgets/grf_bars.dart';
import 'package:innohproject/src/widgets/warrantytable.dart';

class GraficaTablaModal {
  static void mostrar(
    BuildContext context, {
    required List<BarChartGroupData> datos,
    required List<String> marcas,
    required String emitidoPor,
    required String subtitulo,
    required String descripcion,
    required String titulo,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Encabezado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: Row(
                        children: [
                          // Gráfica
                          Expanded(
                            flex: 3,
                            child: GrfBars(
                              datos: datos,
                              marcas: marcas,
                              emitidoPor: emitidoPor,
                              subtitulo: subtitulo,
                              descripcion: descripcion,
                              titulo: titulo,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Tabla
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const WarrantyTable(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
