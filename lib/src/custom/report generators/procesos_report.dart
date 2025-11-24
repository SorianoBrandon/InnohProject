import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_report.dart';

/// Generador del reporte de garantías en proceso (Estado == 1)
class ProcesosReport {
  static Future<pw.Document> build() async {
    final firestore = FirebaseFirestore.instance;
    final garantias = await firestore
        .collection('Garantias')
        .where('Estado', isEqualTo: 1)
        .get();

    final datos = <Map<String, dynamic>>[];

    for (int i = 0; i < garantias.docs.length; i++) {
      final doc = garantias.docs[i].data();
      final codigoProducto = doc['CodigoProducto'];
      final dni = doc['DNI'];
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

      // Estado textual (solo 1 aquí)
      final estadoTexto = 'En proceso';

      // Fecha cierre
      final fechaCierre = DateFormat('dd/MM/yyyy').format(fechaVenc);

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
      titulo: "Listado de Garantías en Proceso",
      data: datos,
    );
  }
}
