import 'package:flutter/material.dart';
import 'package:innohproject/src/Views/modal/reportprint_mdl.dart';
import 'package:innohproject/src/custom/custom_productogarantias.dart';
import 'package:innohproject/src/custom/custom_productoreincidente.dart';
import 'package:innohproject/src/custom/custom_topgarantias.dart';
import 'package:innohproject/src/helpers/reportproducthelper.dart';
import 'package:innohproject/src/helpers/reportreincidenciahelper.dart';
import 'package:innohproject/src/widgets/reportdescriber.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_Listadopdf.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/reportlisthelper.dart';


//Sale modificado pero como no subo al git nunca se me quita lo modificado al guardar xd
//asi que supongo que esta igual que el dia de la defensa,no deberia haber cambio alguno

class ReportListWarrantyMdl extends StatelessWidget {
  const ReportListWarrantyMdl({super.key});

  Future<pw.Document> _buildGeneralReport() async {
    final datos = await construirListadoGarantias();
    return await ReportGeneral.build(datos);
  }

  Future<pw.Document> _buildProductosEnProcesoPdf() async {
  final datos = await ListadoProductosEnProceso(); 
  return await ReportProcesos.build(datos);
}

  Future<pw.Document> _buildReimpresionGarantiaPdf() async {
    final fechaCompra = '10/11/2025';
final articulo = 'Televisor LED 42"';
final modelo = 'TV42X';
final serie = 'SN123456789';
final codigoGarantia = 'REIMPGAR01072-3223-1512';
  return await ReportGarantiaReimpresion.build(
    fechaCompra: fechaCompra,
    articulo: articulo,
    modelo: modelo,
    serie: serie,
    codigoGarantia: codigoGarantia,
  );
}

Future<pw.Document> _buildReincidenciasPdf() async {
  final datos = await listadoReincidentes();
  return await ReportReincidencias.build(datos);
}

Future<pw.Document> _buildTop5Pdf() async {
  final pdf = await ReportTop5Antiguas.build();
  return pdf;
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
                      title: 'Listado General de Garantías',
                      description: 'Genera una lista detallada de todas las garantías',
                      buildPdf: _buildGeneralReport,
                      filename: 'ListadoGarantiasGeneral.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                    ReportDescriber(
                      title: 'Productos en Proceso de Garantías',
                      description: 'Listado solo de garantías con estado en proceso',
                      buildPdf:_buildProductosEnProcesoPdf,
                      filename: 'ProductosProcesosGarantias.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                    ReportDescriber(
                      title: 'Reimpresión de Garantías',
                      description: 'Imprime nuevamente una garantía específica',
                      buildPdf:_buildReimpresionGarantiaPdf,
                      filename: 'HojadeGarantia.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                     ReportDescriber(
                      title: 'Productos con Reincidencia de Garantías',
                      description: 'Lista todos los productos con uno o más reincidencias en garantías',
                      buildPdf:_buildReincidenciasPdf,
                      filename: 'ProductosReincidentes.pdf',
                      previewColor: EnvColors.azulito,
                      pdfColor: EnvColors.verdete,
                    ),
                    ReportDescriber(
                      title: 'Top 5 Garantías Más Antiguas Pendientes',
                      description: 'Lista de las 5 garantías más antiguas que se deben atender',
                      buildPdf:_buildTop5Pdf,
                      filename: 'Top5Garantias.pdf',
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
