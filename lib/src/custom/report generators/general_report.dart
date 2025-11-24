import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_report.dart';

/// Generador del reporte general de garantías
class GeneralReport {
  /// Construye el PDF del listado general de garantías
  static Future<pw.Document> build() async {
    final firestore = FirebaseFirestore.instance;
    final garantias = await firestore.collection('Garantias').get();

    final datos = <Map<String, dynamic>>[];

    for (int i = 0; i < garantias.docs.length; i++) {
      final doc = garantias.docs[i].data();
      final codigoProducto = doc['CodigoProducto'];
      final dni = doc['DNI'];
      final estado = doc['Estado'];
      final ns = doc['NS'];
      final fechaVenc = (doc['FechaVencimiento'] as Timestamp).toDate();

      // Producto
      final productoSnap = await firestore
          .collection('Productos')
          .doc(codigoProducto)
          .get();
      final productoData = productoSnap.data();
      final nombreProducto = productoData?['Descripcion'] ?? 'Desconocido';
      final proveedor = productoData?['Marca'] ?? 'Sin marca';

      // Cliente
      final clienteSnap = await firestore
          .collection('Clientes')
          .doc(dni.trim())
          .get();
      final clienteData = clienteSnap.data();
      final nombreCliente = clienteData?['Name'] ?? 'Sin nombre';

      // Estado textual (solo 0 y 1)
      String estadoTexto;
      if (estado == 0) {
        estadoTexto = 'Base (sin reclamo)';
      } else if (estado == 1) {
        estadoTexto = 'En proceso';
      } else {
        estadoTexto = 'Desconocido';
      }

      // Fecha cierre (solo si está en proceso, sino "-")
      final fechaCierre = estado == 1
          ? DateFormat('dd/MM/yyyy').format(fechaVenc)
          : '-';

      // Días restantes
      final diasRestantes = fechaVenc.difference(DateTime.now()).inDays;

      datos.add({
        'id': dni + ns,
        'producto': nombreProducto,
        'cliente': nombreCliente,
        'proveedor': proveedor,
        'estado': estadoTexto,
        'fechaCierre': fechaCierre,
        'diasRestantes': diasRestantes,
      });
    }

    // Generar el PDF con CustomReport
    return await CustomReport.build(
      titulo: "Listado General de Garantías",
      data: datos,
    );
  }
}
