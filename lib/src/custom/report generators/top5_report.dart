import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportTop5Antiguas {
  static Future<pw.Document> build({
    required int trimestre,
    required int anio,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fechaGenerado = DateFormat('dd-MM-yyyy HH:mm').format(now);

    // Logo
    final logoBytes = await rootBundle.load('assets/Logo.jpg');
    final logoImage = pw.MemoryImage(Uint8List.view(logoBytes.buffer));

    // 🔹 Calcular rango de fechas según trimestre
    final inicio = _inicioTrimestre(trimestre, anio);
    final fin = _finTrimestre(trimestre, anio);
    final periodoTexto = _periodoTrimestre(trimestre, anio);

    // 1. Consulta Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('Garantias')
        .get();

    final docs = snapshot.docs.map((doc) {
      final data = doc.data();
      data['idGarantia'] = doc.id;
      return data;
    }).toList();

    // 2. Filtrar estado == 1 y fechaEntrada dentro del trimestre
    final filtrados = docs.where((e) {
      final estado = e['Estado'] ?? -1;
      final fechaEntrada = toDate(e['FechaEntrada']);
      return estado == 1 &&
          fechaEntrada != null &&
          fechaEntrada.isAfter(inicio) &&
          fechaEntrada.isBefore(fin);
    }).toList();

    // 3. Ordenar por fechaEntrada ascendente
    filtrados.sort((a, b) {
      final da = toDate(a['FechaEntrada']);
      final db = toDate(b['FechaEntrada']);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });

    // 4. Top 5
    final top5 = filtrados.take(5).toList();

    // 5. Transformación para la tabla
    final items = top5.map((e) {
      final fechaEntrada = toDate(e['FechaEntrada']);
      return {
        'fechaEntrada': fechaEntrada == null
            ? 'N/D'
            : DateFormat('dd-MM-yyyy').format(fechaEntrada),
        'idGarantia': e['idGarantia'] ?? 'Sin ID',
        'numSerie': e['NS'] ?? 'Sin NS',
        'nombrePr': e['NombrePr'] ?? 'Sin nombre',
        'estadoTexto': 'Solución insuficiente',
      };
    }).toList();

    // 6. Construcción del PDF
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
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
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.Image(logoImage, width: 80),
            ],
          ),
          pw.SizedBox(height: 12),

          // Título
          pw.Center(
            child: pw.Text(
              'Top 5 Garantías más antiguas sin resolver',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),

          // Periodo debajo del título
          pw.Center(
            child: pw.Text(
              'Periodo: $periodoTexto',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.SizedBox(height: 12),

          // Tabla
          pw.TableHelper.fromTextArray(
            headers: const [
              'Fecha Entrada',
              'Id Garantía',
              'Número de Serie',
              'Producto',
              'Estado',
            ],
            data: items
                .map(
                  (e) => [
                    e['fechaEntrada'],
                    e['idGarantia'],
                    e['numSerie'],
                    e['nombrePr'],
                    e['estadoTexto'],
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromInt(EnvColors.verdete.toARGB32()),
            ),
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey600),
          ),

          pw.SizedBox(height: 8),

          // Generado al final
          pw.Text(
            'Generado: $fechaGenerado',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Text(
            'Confidencial - Uso interno',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
    return pdf;
  }

  // Helpers para calcular inicio/fin de trimestre
  static DateTime _inicioTrimestre(int trimestre, int anio) {
    switch (trimestre) {
      case 1:
        return DateTime(anio, 1, 1);
      case 2:
        return DateTime(anio, 4, 1);
      case 3:
        return DateTime(anio, 7, 1);
      case 4:
        return DateTime(anio, 10, 1);
      default:
        return DateTime(anio, 1, 1);
    }
  }

  static DateTime _finTrimestre(int trimestre, int anio) {
    switch (trimestre) {
      case 1:
        return DateTime(anio, 3, 31, 23, 59, 59);
      case 2:
        return DateTime(anio, 6, 30, 23, 59, 59);
      case 3:
        return DateTime(anio, 9, 30, 23, 59, 59);
      case 4:
        return DateTime(anio, 12, 31, 23, 59, 59);
      default:
        return DateTime(anio, 12, 31, 23, 59, 59);
    }
  }

  static String _periodoTrimestre(int trimestre, int anio) {
    switch (trimestre) {
      case 1:
        return 'Enero - Marzo $anio';
      case 2:
        return 'Abril - Junio $anio';
      case 3:
        return 'Julio - Septiembre $anio';
      case 4:
        return 'Octubre - Diciembre $anio';
      default:
        return '$anio';
    }
  }

  // Conversión segura de Timestamp a DateTime
  static DateTime? toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is Timestamp) return v.toDate();
    return null;
  }
}
