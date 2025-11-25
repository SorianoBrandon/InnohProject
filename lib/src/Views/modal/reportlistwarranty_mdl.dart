import 'package:flutter/material.dart';
import 'package:innohproject/src/custom/custom_topgarantias.dart';
import 'package:innohproject/src/custom/report%20generators/general_report.dart';
import 'package:innohproject/src/custom/report%20generators/procesos_report.dart';
import 'package:innohproject/src/custom/report%20generators/reincidencias_report.dart';
import 'package:innohproject/src/helpers/snackbars.dart';
import 'package:innohproject/src/env/env_Colors.dart';
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
                    SizedBox(
                      height: 100,
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        perspective: 0.005,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            semanaSeleccionada = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final semana = index + 1;
                            return Center(
                              child: Text(
                                "Semana $semana",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: semana == semanaSeleccionada
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: semana == semanaSeleccionada
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildYearWheel(),
                    const SizedBox(height: 12),
                    _buildButtons(
                      activeFilter == ReportFilterType.semanal,
                      buildPdf: ProcesosReport.build,
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
                      value: quincenaSeleccionada,
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
                    _buildYearWheel(),
                    const SizedBox(height: 12),
                    _buildButtons(
                      activeFilter == ReportFilterType.quincenal,
                      buildPdf: GeneralReport.build,
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
                    _buildYearWheel(),
                    const SizedBox(height: 12),

                    _buildButtons(
                      activeFilter == ReportFilterType.mensual,
                      buildPdf: ReincidenciasReport.build,
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
                      value: trimestreSeleccionado,
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
                    _buildYearWheel(),
                    const SizedBox(height: 12),

                    _buildButtons(
                      activeFilter == ReportFilterType.trimestral,
                      buildPdf: ReportTop5Antiguas.build,
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
  Widget _buildYearWheel() {
    return SizedBox(
      height: 100,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            anioSeleccionado = 2000 + index;
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final year = 2000 + index;
            return Center(
              child: Text(
                year.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: year == anioSeleccionado
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: year == anioSeleccionado ? Colors.blue : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔹 Selector de mes
  Widget _buildMonthSelector() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Mes',
      ),
      value: mesSeleccionado,
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

  // 🔹 Botones de acción
  Widget _buildButtons(
    bool isActive, {
    required Future<pw.Document> Function() buildPdf,
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
                    final pdf = await buildPdf();
                    await Printing.layoutPdf(
                      onLayout: (format) async => pdf.save(),
                    );
                  } catch (e) {
                    ErrorSnackbar.show(context, "Error al previsualizar: $e");
                  }
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
                    final pdf = await buildPdf();
                    await Printing.sharePdf(
                      bytes: await pdf.save(),
                      filename: filename,
                    );
                  } catch (e) {
                    ErrorSnackbar.show(context, "Error al imprimir: $e");
                  }
                }
              : null,
        ),
      ],
    );
  }
}
