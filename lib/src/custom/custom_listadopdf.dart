import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; //asi lo recomienda la docu oficial

class ReportGeneral {
  static Future<pw.Document> build(List<Map<String, dynamic>> reporte) async {
    final pdf = pw.Document();

    pdf.addPage(
      
      pw.MultiPage(//para que pueda ser mas de una pagina si se pasa en teoria 
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "Listado General de Garantías",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Aquí va la tabla
          pw.TableHelper.fromTextArray(
            headers: [
              "Nº Garantía",
              "Producto",
              "Cliente",
              "Proveedor",
              "Estado",
              "Fecha Cierre",
              "Días Restantes"
            ],
            data: reporte.map((r) => [
              r['numero'],
              r['producto'],
              r['cliente'],
              r['proveedor'],
              r['estado'],
              r['fechaCierre'],
              r['diasRestantes'].toString(),
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            border: pw.TableBorder.all(width: 0.5),
          ),
        ],
      ),
    );

    return pdf;
  }
}
