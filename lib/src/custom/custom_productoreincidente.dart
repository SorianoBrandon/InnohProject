import 'package:flutter/services.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

//Sale modificado pero como no subo al git nunca se me quita lo modificado al guardar xd
//asi que supongo que esta igual que el dia de la defensa,no deberia haber cambio alguno

class ReportReincidencias {
  static Future<pw.Document> build(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final logoBytes = await rootBundle.load('assets/Logo.jpg');
    final logoImage = pw.MemoryImage(Uint8List.view(logoBytes.buffer));
    final fechaEmision = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
                  
                  pw.Text('Innovah Comercial',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Departamento: Gerencia',
                      style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.Image(logoImage, width: 80),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Center(
            child: pw.Text('Listado de productos reincidentes',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 16),


          // Tabla
          pw.TableHelper.fromTextArray(
            headers: ['Producto', 'Marca', 'Fecha', 'Nivel', 'Problema'],
            data: data.map((e) => [
              e['producto'],
              e['marca'],
              e['fecha'],
              e['nivel'],
              e['problema'],
            ]).toList(),
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
  },
          ),

          pw.SizedBox(height: 16),

          // Leyenda
          pw.Text('Leyenda de niveles de reincidencia:',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('Alto: más de 4 reclamos registrados',
               style: const pw.TextStyle(fontSize: 9)),
          pw.Text('Medio: entre 2 y 4 reclamos',
              style: const pw.TextStyle(fontSize: 9)),
          pw.Text('Bajo: menos de 2 reclamos',
              style: const pw.TextStyle(fontSize: 9)),


          pw.SizedBox(height: 12),

          // Observación
          pw.Text(
            'Observación: Los productos con nivel "Alto" requieren evaluación de proveedor o revisión de lote.',
            style: const pw.TextStyle(fontSize: 9),
          ),

          pw.SizedBox(height: 12),
          pw.Text('Fecha de emisión: $fechaEmision',
              style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );

    return pdf;
  }
}
