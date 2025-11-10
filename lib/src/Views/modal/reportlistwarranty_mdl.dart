import 'package:flutter/material.dart';
import 'package:innohproject/src/helpers/reportproducthelper.dart';
import 'package:innohproject/src/widgets/reportdescriber.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_Listadopdf.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/reportlisthelper.dart';


class ReportListWarrantyMdl extends StatelessWidget {
  const ReportListWarrantyMdl({super.key});

  Future<pw.Document> _buildGeneralReport() async {
    final datos = await construirListadoGarantias();
    return await ReportGeneral.build(datos);
  }

  Future<pw.Document> _buildProductosEnProcesoPdf() async {
  final datos = await ListadoProductosEnProceso(); 
  return await ReportGeneral.build(datos);
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
              const Text('Reportes disponibles', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportDescriber(
                      title: 'Listado general de Garantías',
                      description: 'Genera una lista detallada de todas las garantías',
                      buildPdf: _buildGeneralReport,
                      filename: 'ListadoGarantiasGeneral.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                    ReportDescriber(
                      title: 'Productos en Proceso de Garantías',
                      description: 'Listado solo de garantías con estado En proceso',
                      buildPdf:_buildProductosEnProcesoPdf,
                      filename: 'ProductosProcesosGarantias.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                    // agrega más 
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
