import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:innohproject/src/env/env_Colors.dart';

class CustomReport {
  /// Construye un PDF con el listado de garantías
  static Future<pw.Document> build({
    required String titulo,
    required List<Map<String, dynamic>> data,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    // Fecha de corte: último día del mes actual
    final ultimoDiaMes = DateTime(now.year, now.month + 1, 0);
    final fechaCorte = DateFormat('dd/MM/yyyy').format(ultimoDiaMes);

    final fechaEmision = DateFormat('dd/MM/yyyy - hh:mm a').format(now);

    // Logo corporativo
    final logoBytes = await rootBundle.load('assets/Logo.jpg');
    final logoImage = pw.MemoryImage(Uint8List.view(logoBytes.buffer));

    // Contadores por estado (solo 0 y 1)
    final base = data.where((e) => e['estado'] == 'Sin reclamo').length;
    final enProceso = data.where((e) => e['estado'] == 'En proceso').length;

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Encabezado
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Innovah Comercial',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Departamento: Gerencia',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.Image(logoImage, width: 80),
            ],
          ),
          pw.SizedBox(height: 12),

          // Título dinámico
          pw.Center(
            child: pw.Text(
              titulo,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 16),

          // Recuadro con fecha de corte y total
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey600, width: 1),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Fecha de corte: $fechaCorte',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Total de garantías: ${data.length}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Tabla con encabezado en verdete
          pw.TableHelper.fromTextArray(
            headers: [
              'Id',
              'Producto',
              'Cliente',
              'Proveedor',
              'Estado',
              'Fecha cierre',
              'Días restantes',
            ],
            data: data
                .map(
                  (e) => [
                    e['id'],
                    e['producto'],
                    e['cliente'],
                    e['proveedor'],
                    e['estado'],
                    e['fechaCierre'],
                    e['diasRestantes'].toString(),
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromInt(EnvColors.verdete.toARGB32()),
            ),
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey600),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
              6: pw.Alignment.center,
            },
          ),

          pw.SizedBox(height: 24),

          // Pie de página con desglose
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Sin reclamo: $base',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'En proceso: $enProceso',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Fecha de emisión: $fechaEmision',
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text(
                  'Fuente: Sistema Garantías Innovah',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.Text(
                  'Uso Interno',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}
