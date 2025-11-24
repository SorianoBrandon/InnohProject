import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/env/env_Colors.dart';

//Sale modificado pero como no subo al git nunca se me quita lo modificado al guardar xd
//asi que supongo que esta igual que el dia de la defensa,no deberia haber cambio alguno

class ReportTop5Antiguas {
  /// Método principal: consulta Firestore, procesa datos y genera el PDF
  static Future<pw.Document> build() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fechaGenerado = DateFormat('dd-MM-yyyy HH:mm').format(now);

    // Logo
    final logoBytes = await rootBundle.load('assets/Logo.jpg');
    final logoImage = pw.MemoryImage(Uint8List.view(logoBytes.buffer));

    // 1. Consulta Firestore (sin índices compuestos)
    final snapshot = await FirebaseFirestore.instance
        .collection('Garantias')
        .get();

    final docs = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    // 2. Filtrar en memoria (ejemplo: Estado == 0 → pendientes)
    final filtrados = docs.where((e) => (e['Estado'] ?? -1) == 0).toList();

    // 3. Ordenar por FechaVencimiento ascendente, manejando Timestamp y nulos
    filtrados.sort((a, b) {
      final da = toDate(a['FechaVencimiento']);
      final db = toDate(b['FechaVencimiento']);
      if (da == null && db == null) return 0;
      if (da == null) return 1; // nulos al final
      if (db == null) return -1;
      return da.compareTo(db);
    });

    // 4. Top 5 más antiguos
    final top5 = filtrados.take(5).toList();

    // 5. Transformación para la tabla
    final items = await Future.wait(
      top5.map((e) async {
        final productoId = (e['CodigoProducto'] ?? '').toString();

        // Buscar en Productos por campo Codigo (no por docId)
        final prodQuery = await FirebaseFirestore.instance
            .collection('Productos')
            .where('Codigo', isEqualTo: productoId)
            .limit(1)
            .get();

        final prodData = prodQuery.docs.isNotEmpty
            ? prodQuery.docs.first.data()
            : null;
        final descripcion = prodData?['Descripcion'] ?? 'Sin descripción';
        final marca = prodData?['Marca'] ?? 'Sin marca';

        final fechaVencimiento = toDate(e['FechaVencimiento']);
        final diasTranscurridos = fechaVencimiento == null
            ? 'N/D'
            : DateTime.now()
                  .difference(fechaVencimiento)
                  .inDays
                  .abs()
                  .toString();

        return {
          'NumGarantia': e['NFactura'] ?? 'Sin factura',
          'Descripcion': descripcion,
          'Marca': marca,
          'fechaIngreso': fechaVencimiento == null
              ? 'N/D'
              : DateFormat('dd-MM-yyyy').format(fechaVencimiento),
          'diasTranscurridos': diasTranscurridos,
          'estadoActual': _estadoTexto(e['Estado']),
        };
      }).toList(),
    );

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

          // Título centrado
          pw.Center(
            child: pw.Text(
              'Top 5 Garantías más antiguas pendientes',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),

          // Periodo debajo del título
          pw.Center(
            child: pw.Text(
              'Periodo: ${_periodoTrimestre(now)}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.SizedBox(height: 12),

          // Tabla
          pw.TableHelper.fromTextArray(
            headers: const [
              'Días transcurridos',
              'Nº Garantía',
              'Producto',
              'Proveedor',
              'Fecha de ingreso',
              'Estado actual',
            ],
            data: items
                .map(
                  (e) => [
                    e['diasTranscurridos'],
                    e['NumGarantia'],
                    e['Descripcion'],
                    e['Marca'],
                    e['fechaIngreso'],
                    e['estadoActual'],
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
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
            },
          ),

          pw.SizedBox(height: 8),

          // Generado al final
          pw.Text(
            'Generado: $fechaGenerado',
            style: const pw.TextStyle(fontSize: 9),
          ),

          // Confidencial debajo
          pw.Text(
            'Confidencial - Uso interno',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
    return pdf;
  }

  // Traducción de estado
  static String _estadoTexto(dynamic estado) {
    switch (estado) {
      case 0:
        return 'En proceso';
      case 1:
        return 'Activo';
      case 2:
        return 'Eliminado';
      default:
        return 'desconocido';
    }
  }

  // Periodo trimestral
  static String _periodoTrimestre(DateTime dt) {
    final month = dt.month;
    final year = dt.year;
    if (month <= 3) return 'Enero - Marzo $year';
    if (month <= 6) return 'Abril - Junio $year';
    if (month <= 9) return 'Julio - Septiembre $year';
    return 'Octubre - Diciembre $year';
  }

  // Conversión segura de Timestamp a DateTime
  static DateTime? toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is Timestamp) return v.toDate();
    return null;
  }
}
