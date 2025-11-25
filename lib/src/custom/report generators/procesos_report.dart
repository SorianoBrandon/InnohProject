import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:innohproject/src/custom/custom_report.dart';

/// Generador del reporte de garantías en proceso (Estado == 1)
class ProcesosReport {
  static Future<pw.Document> build() async {
    // 🔹 Usar la lista ya filtrada
    final garantias = WarrantyListController.listaReportes;

    final datos = <Map<String, dynamic>>[];

    for (final g in garantias) {
      // Solo incluir las que están en proceso
      if (g.estado == 1) {
        final nombreProducto = g.nombrePr;
        final proveedor = g.marca;
        final nombreCliente = g.nombreCl.trim();

        // Estado textual
        const estadoTexto = 'En proceso';

        // Fecha cierre
        final fechaCierre = DateFormat('dd/MM/yyyy').format(g.fechaVencimiento);

        // Días restantes
        final diasRestantes = g.fechaVencimiento
            .difference(DateTime.now())
            .inDays;

        datos.add({
          'id': "${g.dni}${g.ns}",
          'producto': nombreProducto,
          'cliente': nombreCliente.isEmpty ? 'Sin nombre' : nombreCliente,
          'proveedor': proveedor,
          'estado': estadoTexto,
          'fechaCierre': fechaCierre,
          'diasRestantes': diasRestantes,
        });
      }
    }

    // Generar el PDF con CustomReport
    return await CustomReport.build(
      titulo: "Listado de Garantías en Proceso",
      data: datos,
    );
  }
}
