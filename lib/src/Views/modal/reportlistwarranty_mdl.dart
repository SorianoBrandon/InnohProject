import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/custom/custom_report_general.dart';
import 'package:innohproject/src/custom/report%20generators/procesos_report.dart';
import 'package:innohproject/src/custom/report%20generators/reincidencias_report.dart';
import 'package:innohproject/src/custom/report%20generators/top5_report.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

enum ReportFilterType { none, semanal, quincenal, mensual, trimestral }

class ReportListWarrantyMdl extends StatefulWidget {
  const ReportListWarrantyMdl({super.key});

  @override
  State<ReportListWarrantyMdl> createState() => _ReportListWarrantyMdlState();
}

class _ReportListWarrantyMdlState extends State<ReportListWarrantyMdl> {
  ReportFilterType activeFilter = ReportFilterType.none;

  int anioSeleccionado = DateTime.now().year;
  int? mesSeleccionado;
  int? semanaSeleccionada;
  int? quincenaSeleccionada;
  int? trimestreSeleccionado;

  final List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  void setActiveFilter(ReportFilterType type) {
    setState(() {
      activeFilter = type;
      mesSeleccionado = null;
      semanaSeleccionada = null;
      quincenaSeleccionada = null;
      trimestreSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reportes disponibles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 🔹 Card Semanal
              _buildCard(
                title: "Reportes Semanales",
                type: ReportFilterType.semanal,
                child: Column(
                  children: [
                    Text(
                      "Reporte de Garantías en Proceso",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey, // 👈 subtítulo más tenue
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Scroll infinito de semanas
                    _buildWeekSelector(anioSeleccionado),
                    const SizedBox(height: 12),
                    _buildYearSelector(),
                    const SizedBox(height: 12),
                    _buildButtons(
                      activeFilter == ReportFilterType.semanal,
                      buildPdf: () async {
                        if (semanaSeleccionada == null) {
                          ErrorSnackbar.show(
                            context,
                            'Debes seleccionar semana y año antes de generar el reporte',
                          );
                          return null; // 👈 evita que intente generar el PDF
                        }

                        final controller = Get.find<WarrantyListController>();
                        await _aplicarFiltros(controller);

                        return await ProcesosReport.build();
                      },
                      filename: 'ProductosProcesosGarantias.pdf',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Card Quincenal
              _buildCard(
                title: "Reportes Quincenales",
                type: ReportFilterType.quincenal,
                child: Column(
                  children: [
                    Text(
                      "Reporte General de Garantías",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey, // 👈 subtítulo más tenue
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quincena',
                      ),
                      initialValue: quincenaSeleccionada,
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("Primera Quincena"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("Segunda Quincena"),
                        ),
                      ],
                      onChanged: activeFilter == ReportFilterType.quincenal
                          ? (v) => setState(() => quincenaSeleccionada = v)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildMonthSelector(),
                    const SizedBox(height: 12),
                    _buildYearSelector(),
                    const SizedBox(height: 12),
                    _buildButtons(
                      activeFilter == ReportFilterType.quincenal,
                      buildPdf: () async {
                        if (quincenaSeleccionada == null ||
                            mesSeleccionado == null) {
                          ErrorSnackbar.show(
                            context,
                            'Debes seleccionar quincena, mes y año antes de generar el reporte',
                          );
                          return null;
                        }

                        final periodo =
                            '${quincenaSeleccionada == 1 ? 'Primera' : 'Segunda'} quincena de ${meses[mesSeleccionado! - 1]} $anioSeleccionado';

                        final garantias = WarrantyListController.listaReportes;
                        final data = garantias
                            .map(
                              (g) => {
                                'id': "${g.dni}${g.ns}",
                                'producto': g.nombrePr,
                                'cliente': g.nombreCl.trim().isEmpty
                                    ? 'Sin nombre'
                                    : g.nombreCl.trim(),
                                'fechaEntrada': DateFormat(
                                  'dd/MM/yyyy',
                                ).format(g.fechaEntrada),
                                'fechaVencimiento': DateFormat(
                                  'dd/MM/yyyy',
                                ).format(g.fechaVencimiento),
                                'numIncidencias': g.numIncidente,
                              },
                            )
                            .toList();

                        return await CustomReportGeneral.build(
                          data: data,
                          periodo: periodo,
                          titulo: 'Lista General de Garantías',
                        );
                      },
                      filename: 'ListaGeneralGarantias.pdf',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Card Mensual
              _buildCard(
                title: "Reportes Mensuales",
                type: ReportFilterType.mensual,
                child: Column(
                  children: [
                    Text(
                      "Garantia de Reincidencias",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    _buildMonthSelector(),
                    const SizedBox(height: 12),
                    _buildYearSelector(),
                    const SizedBox(height: 12),

                    _buildButtons(
                      activeFilter == ReportFilterType.mensual,
                      buildPdf: () async {
                        if (mesSeleccionado == null) {
                          ErrorSnackbar.show(
                            context,
                            'Debes seleccionar mes y año antes de generar el reporte',
                          );
                          return null;
                        }

                        final garantias = WarrantyListController.listaReportes;
                        final data = garantias
                            .map(
                              (g) => {
                                'id': "${g.dni}${g.ns}",
                                'producto': g.nombrePr,
                                'marca': g.marca,
                                'reincidencias': g.numIncidente,
                              },
                            )
                            .toList();

                        return await CustomReportReincidencias.build(
                          titulo: 'Reporte de Reincidencias Mensual',
                          data: data,
                        );
                      },
                      filename: 'ProductosReincidentes.pdf',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Card Trimestral
              _buildCard(
                title: "Reportes Trimestrales",
                type: ReportFilterType.trimestral,
                child: Column(
                  children: [
                    Text(
                      "Top 5 garantias más antiguas",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Trimestre',
                      ),
                      initialValue: trimestreSeleccionado,
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("1er Trimestre"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("2do Trimestre"),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text("3er Trimestre"),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text("4to Trimestre"),
                        ),
                      ],
                      onChanged: activeFilter == ReportFilterType.trimestral
                          ? (v) => setState(() => trimestreSeleccionado = v)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildYearSelector(),
                    const SizedBox(height: 12),

                    _buildButtons(
                      activeFilter == ReportFilterType.trimestral,
                      buildPdf: () async {
                        if (trimestreSeleccionado == null) {
                          ErrorSnackbar.show(
                            context,
                            'Debes seleccionar trimestre y año antes de generar el reporte',
                          );
                          return null;
                        }

                        return await ReportTop5Antiguas.build(
                          trimestre: trimestreSeleccionado!,
                          anio: anioSeleccionado,
                        );
                      },
                      filename: 'Top5GarantiasAntiguas.pdf',
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helpers
  Widget _buildCard({
    required String title,
    required ReportFilterType type,
    required Widget child,
  }) {
    final isActive = activeFilter == type;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                value: isActive,
                onChanged: (v) {
                  setActiveFilter(v == true ? type : ReportFilterType.none);
                },
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  // 🔹 Scroll infinito de años
  Widget _buildYearSelector() {
    // Genera una lista de años desde 2000 hasta el actual + 5
    final currentYear = DateTime.now().year;
    final years = List.generate(
      (currentYear - 2000) + 6, // rango dinámico
      (i) => 2000 + i,
    );

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Año',
      ),
      initialValue: anioSeleccionado,
      items: years.map((y) {
        return DropdownMenuItem(value: y, child: Text(y.toString()));
      }).toList(),
      onChanged: (v) {
        setState(() {
          anioSeleccionado = v!;
        });
      },
    );
  }

  // 🔹 Selector de mes
  Widget _buildMonthSelector() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Mes',
      ),
      initialValue: mesSeleccionado,
      items: List.generate(meses.length, (i) {
        return DropdownMenuItem(value: i + 1, child: Text(meses[i]));
      }),
      onChanged:
          activeFilter == ReportFilterType.mensual ||
              activeFilter == ReportFilterType.quincenal
          ? (v) => setState(() => mesSeleccionado = v)
          : null,
    );
  }

  Future<void> _aplicarFiltros(WarrantyListController controller) async {
    switch (activeFilter) {
      case ReportFilterType.semanal:
        if (semanaSeleccionada != null) {
          await controller.cargarSemanalEnProceso(
            semanaSeleccionada!,
            anioSeleccionado,
          );
        }
        break;

      case ReportFilterType.quincenal:
        if (quincenaSeleccionada != null && mesSeleccionado != null) {
          await controller.cargarQuincenal(
            quincenaSeleccionada!,
            mesSeleccionado!,
            anioSeleccionado,
          );
        }
        break;

      case ReportFilterType.mensual:
        if (mesSeleccionado != null) {
          await controller.cargarMensual(mesSeleccionado!, anioSeleccionado);
        }
        break;

      case ReportFilterType.trimestral:
        if (trimestreSeleccionado != null) {
          await controller.cargarTrimestral(
            trimestreSeleccionado!,
            anioSeleccionado,
          );
        }
        break;

      case ReportFilterType.none:
        break;
    }
  }

  DateTime _isoWeekStart(int year, int week) {
    // ISO: semana 1 es la que contiene el primer jueves del año
    final jan4 = DateTime(year, 1, 4);
    final jan4Weekday = jan4.weekday; // 1=Lunes ... 7=Domingo
    final mondayOfWeek1 = jan4.subtract(
      Duration(days: jan4Weekday - DateTime.monday),
    );
    return mondayOfWeek1.add(Duration(days: (week - 1) * 7));
  }

  DateTime _isoWeekEnd(int year, int week) {
    final start = _isoWeekStart(year, week);
    return start.add(const Duration(days: 6));
  }

  int isoWeeksInYear(int year) {
    int w = 1;
    while (true) {
      final start = _isoWeekStart(year, w);
      if (start.year > year) break;
      w++;
      if (w > 60) break; // seguridad
    }
    return w - 1;
  }

  Widget _buildWeekSelector(int year) {
    final totalWeeks = isoWeeksInYear(year);
    final formatter = DateFormat('dd/MM');

    final items = List.generate(totalWeeks, (i) {
      final week = i + 1;
      final start = _isoWeekStart(year, week);
      final end = _isoWeekEnd(year, week);
      final label =
          "Semana $week (${formatter.format(start)}–${formatter.format(end)})";

      return DropdownMenuItem<int>(value: week, child: Text(label));
    });

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Semana',
      ),
      value: semanaSeleccionada,
      items: items,
      onChanged: (v) {
        setState(() {
          semanaSeleccionada = v!;
        });
      },
    );
  }

  // 🔹 Botones de acción
  Widget _buildButtons(
    bool isActive, {
    required Future<pw.Document?> Function() buildPdf,
    required String filename,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.visibility),
          label: const Text("Previsualizar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: EnvColors.azulito,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isActive
              ? () async {
                  try {
                    final controller = Get.find<WarrantyListController>();
                    await _aplicarFiltros(controller);
                    final pdf = await buildPdf();
                    await Printing.layoutPdf(
                      onLayout: (format) async {
                        final bytes = await pdf!.save();
                        return bytes;
                      },
                    );
                  } catch (e) {}
                }
              : null,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: const Text("PDF"),
          style: ElevatedButton.styleFrom(
            backgroundColor: EnvColors.verdete,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isActive
              ? () async {
                  try {
                    final controller = Get.find<WarrantyListController>();
                    await _aplicarFiltros(controller);

                    final pdf = await buildPdf();
                    await Printing.sharePdf(
                      bytes: await pdf!.save(),
                      filename: filename,
                    );
                  } catch (e) {}
                }
              : null,
        ),
      ],
    );
  }
}
