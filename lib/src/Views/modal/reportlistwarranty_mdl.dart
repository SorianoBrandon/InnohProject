import 'package:flutter/material.dart';
import 'package:innohproject/src/custom/custom_topgarantias.dart';
import 'package:innohproject/src/custom/report%20generators/general_report.dart';
import 'package:innohproject/src/custom/report%20generators/procesos_report.dart';
import 'package:innohproject/src/custom/report%20generators/reincidencias_report.dart';
import 'package:innohproject/src/widgets/reportdescriber.dart';

import 'package:innohproject/src/env/env_Colors.dart';

class ReportListWarrantyMdl extends StatelessWidget {
  const ReportListWarrantyMdl({super.key});

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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Sección Semanal
                    Text(
                      'Reportes Semanales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        decorationThickness: 1,
                      ),
                    ),
                    ReportDescriber(
                      title: 'Productos en Proceso de Garantías',
                      description:
                          'Listado solo de garantías con estado en proceso',
                      buildPdf: ProcesosReport.build, // 👈 se mantiene igual
                      filename: 'ProductosProcesosGarantias.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Sección Quincenal
                    Text(
                      'Reportes Quincenales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        decorationThickness: 1,
                      ),
                    ),
                    ReportDescriber(
                      title: 'Listado General de Garantías',
                      description:
                          'Genera una lista detallada de todas las garantías',
                      buildPdf: GeneralReport.build, // 👈 se mantiene igual
                      filename: 'ListadoGarantiasGeneral.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Sección Mensual
                    Text(
                      'Reportes Mensuales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        decorationThickness: 1,
                      ),
                    ),
                    ReportDescriber(
                      title: 'Productos con Reincidencia de Garantías',
                      description:
                          'Lista todos los productos con uno o más reincidencias en garantías',
                      buildPdf:
                          ReincidenciasReport.build, // 👈 se mantiene igual
                      filename: 'ProductosReincidentes.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Sección Trimestral
                    Text(
                      'Reportes Trimestrales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                        decorationThickness: 1,
                      ),
                    ),
                    ReportDescriber(
                      title: 'Top 5 Garantías Más Antiguas en Proceso',
                      description:
                          'Lista de las 5 garantías más antiguas que siguen en estado 1 (en proceso)',
                      buildPdf:
                          ReportTop5Antiguas.build, // 👈 se mantiene igual
                      filename: 'Top5GarantiasAntiguas.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
