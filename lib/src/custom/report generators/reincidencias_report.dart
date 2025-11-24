import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_report.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class ReincidenciasReport {
  static Future<pw.Document> build() async {
    // Si listaReportes es RxList, accede con .value
    final garantias = WarrantyListController.listaReportes;
    final datos = <Map<String, dynamic>>[];

    for (int i = 0; i < garantias.length; i++) {
      final g = garantias[i];

      // 👈 Filtrar solo las reincidencias
      if (g.numIncidente == 0) continue;

      String estadoTexto;
      if (g.estado == 0) {
        estadoTexto = 'Base (sin reclamo)';
      } else if (g.estado == 1) {
        estadoTexto = 'En proceso';
      } else {
        estadoTexto = 'Desconocido';
      }

      final fechaCierre = g.estado == 1
          ? DateFormat('dd/MM/yyyy').format(g.fechaVencimiento)
          : '-';

      final diasRestantes = g.fechaVencimiento
          .difference(DateTime.now())
          .inDays;

      datos.add({
        'id': g.dni + g.ns,
        'producto': g.nombrePr,
        'cliente': g.nombreCl,
        'estado': estadoTexto,
        'fechaCierre': fechaCierre,
        'diasRestantes': diasRestantes,
        'reincidencias': g.numIncidente,
      });
    }

    return await CustomReport.build(
      titulo: "Listado de Garantías con Reincidencias",
      data: datos,
    );
  }
}
