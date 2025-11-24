import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:innohproject/src/atom/grf/grf_marcascontroller.dart';
import 'package:innohproject/src/atom/grf/grf_mproductoscontroller.dart';
import 'package:innohproject/src/atom/grf/grf_pmarcascontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/widgets/grf_bars.dart';
import 'package:innohproject/src/widgets/warrantytable.dart';

class GraficasdMdl extends StatelessWidget {
  const GraficasdMdl({super.key});

  void mostrarGrafica(BuildContext context, String titulo, int grf) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // transparente para que se vea el borde
      builder: (context) => SizedBox.expand(
        // ✅ ocupa todo el ancho y alto
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con botón de cierre
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Contenido principal
                Expanded(
                  child: Row(
                    children: [
                      // Panel izquierdo: gráfica
                      Expanded(
                        flex: 3,
                        child: Builder(
                          builder: (context) {
                            switch (grf) {
                              case 1:
                                return FutureBuilder<List<BarChartGroupData>>(
                                  future: GrfMarcasController()
                                      .generarDatosBarra(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return GrfBars(
                                      datos: snapshot.data!,
                                      emitidoPor: CurrentLog.employ!.user,
                                      marcas: GrfMarcasController.marcas,
                                      subtitulo: 'Reporte Total',
                                    );
                                  },
                                );
                              case 2:
                                return FutureBuilder<List<BarChartGroupData>>(
                                  future: GrfMproductoscontroller()
                                      .generarDatosBarraPorTipo('Sony'),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return GrfBars(
                                      datos: snapshot.data!,
                                      emitidoPor: CurrentLog.employ!.user,
                                      marcas: GrfMproductoscontroller.tipos,
                                      titulo: 'Fallo de Productos',
                                      subtitulo: 'Marca Sony',
                                    );
                                  },
                                );
                              case 3:
                                return FutureBuilder<List<BarChartGroupData>>(
                                  future: GrfPmarcascontroller()
                                      .generarDatosBarraPorTipo('Consola'),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return GrfBars(
                                      datos: snapshot.data!,
                                      emitidoPor: CurrentLog.employ!.user,
                                      marcas: GrfPmarcascontroller.marcas,
                                      titulo:
                                          'Fallo Tipo de Producto entre Marcas',
                                      subtitulo: 'Tipo Consolas',
                                    );
                                  },
                                );
                              default:
                                return const Text(
                                  'Tipo de gráfico no reconocido',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Panel derecho: tabla con scrollbars
                      Expanded(flex: 4, child: WarrantyTable()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonGrafico(BuildContext context, String label, int grf) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.blue.shade300,
          ),
          onPressed: () async {
            mostrarGrafica(context, label, grf);
          },
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una gráfica:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _botonGrafico(context, 'Porcentaje de Fallas Entre Marcas', 1),
                _botonGrafico(context, 'Fallas Productos de Marca', 2),
                _botonGrafico(context, 'Falla Producto Entre Marcas', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
