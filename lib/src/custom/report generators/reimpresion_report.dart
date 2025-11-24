import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class ReportGarantiaReimpresion {
  static Future<pw.Document> build({
    required String garantiaId, // id del documento en Garantias
  }) async {
    final firestore = FirebaseFirestore.instance;

    // Crear un QrPainter y convertirlo a ui.Image
    final qrPainter = QrPainter(
      data: garantiaId,
      version: QrVersions.auto,
      gapless: true,
      color: ui.Color(0xFF000000),
      emptyColor: ui.Color(0x00000000),
    );

    final uiImage = await qrPainter.toImage(200);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final qrImage = pw.Image(pw.MemoryImage(bytes), width: 100, height: 100);
    // Obtener datos de la garantía
    final docGarantia = await firestore
        .collection('Garantias')
        .doc(garantiaId)
        .get();
    final garantiaData = docGarantia.data()!;

    final fechaCompra = DateFormat(
      'dd/MM/yyyy',
    ).format((garantiaData['FechaEntrada'] as Timestamp).toDate());
    final fechaVencimiento = DateFormat(
      'dd/MM/yyyy',
    ).format((garantiaData['FechaVencimiento'] as Timestamp).toDate());
    final articulo = garantiaData['NombrePr'] ?? 'Sin nombre';
    final serie = garantiaData['NS'] ?? 'Sin serie';
    final codigoProducto = garantiaData['CodigoProducto'];

    // Obtener modelo desde Productos
    final docProducto = await firestore
        .collection('Productos')
        .doc(codigoProducto)
        .get();
    final productoData = docProducto.data();
    final modelo = productoData?['Modelo'] ?? 'Sin modelo';

    // Logo
    final logoBytes = await rootBundle.load('assets/Logo.jpg');
    final logoImage = pw.MemoryImage(Uint8List.view(logoBytes.buffer));

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Encabezado
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'INNOVAH Comercial',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Image(logoImage, width: 80),
            ],
          ),
          pw.SizedBox(height: 16),

          pw.Text(
            'CONDICIONES DE LA GARANTÍA:',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Los productos están garantizados contra defectos de fabricación, causados en condiciones normales de uso, de acuerdo con las indicaciones del fabricante estipuladas en el manual de instrucciones que viene con el producto. Este certificado garantiza la reparación del producto al taller autorizado por el proveedor.',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'LA GARANTÍA NO IMPLICA UN CAMBIO AUTOMÁTICO DEL ARTÍCULO',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'LA GARANTÍA NO SE APLICA EN LOS SIGUIENTES CASOS:',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),

          // Exclusiones
          pw.Bullet(
            text:
                'Daño producido por golpes, rayones, manchas, exposición excesiva al polvo o humedad u otro tipo de daño físico.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Daño causado por variaciones de voltaje o descarga afectada.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Cuando no se presente este certificado y la documentación necesaria al solicitar el servicio de garantía.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Si el producto es intervenido por un taller o persona no autorizada por nuestra empresa.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Daños causados por el uso indebido del producto (uso comercial, abuso, etc.) u otros diferentes para los cuales no ha sido diseñado.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Daños causados por accidentes, causas imprevistas o deliberadas, insectos, roedores, derrame de residuos dentro de las partes y similares.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text: 'Introducción de objetos extraños dentro del artículo.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'La garantía no cubre daños en bombillas, micrófonos, parlantes, baterías, cordones, partes plásticas, vidrios, perillas, antenas, adaptadores, controles remotos, audífonos, empaques, salidas de audio y accesorios.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Bullet(
            text:
                'Cuando los minicomponentes no lean CD"s a causa del uso excesivo de copias de CD"s.',
            style: const pw.TextStyle(fontSize: 9),
          ),

          pw.SizedBox(height: 16),
          // Tabla con datos de la compra
          pw.TableHelper.fromTextArray(
            headers: [
              'FECHA DE COMPRA',
              'FECHA DE VENCIMIENTO',
              'ARTÍCULO',
              'MODELO',
              'SERIE',
            ],
            data: [
              [fechaCompra, fechaVencimiento, articulo, modelo, serie],
            ],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey600),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
            },
          ),

          pw.SizedBox(height: 16),

          // Exclusiones adicionales
          pw.Text(
            'En todos los artículos quedan excluidas las garantías de los vidrios, plásticos,hules, gabinetes, antenas telescópicas, transistores, circuitos integrados de audio, agujas, cristales, transformadores, quemadores y mechas de refrigerador de gas. La garantía nunca está contemplada por defecto de mal manejo PE. enchufar en mal voltaje y por ser revisado por una persona no autorizada de INNOVAH COMERCIAL.',
            style: const pw.TextStyle(fontSize: 9),
          ),

          pw.SizedBox(height: 16),

          // Código de garantía
          qrImage,

          pw.SizedBox(height: 85),
          pw.Center(
            child: pw.Text(
              textAlign: pw.TextAlign.center,
              '____________________________________',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.Center(
            child: pw.Text(
              'FIRMA CLIENTE',

              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}
