import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/custom/custom_report_general.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class GeneralReport {
  static Future<pw.Document> build({
    required DateTime inicioPeriodo,
    required DateTime finPeriodo,
  }) async {
    // 🔹 Usar la lista ya filtrada
    final garantias = WarrantyListController.listaReportes;

    final datos = <Map<String, dynamic>>[];

    for (final g in garantias) {
      final nombreProducto = g.nombrePr;
      final nombreCliente = g.nombreCl.trim();

      datos.add({
        'id': "${g.dni}${g.ns}",
        'producto': nombreProducto,
        'cliente': nombreCliente.isEmpty ? 'Sin nombre' : nombreCliente,
        'fechaEntrada': DateFormat('dd/MM/yyyy').format(g.fechaEntrada),
        'fechaVencimiento': DateFormat('dd/MM/yyyy').format(g.fechaVencimiento),
        'numIncidencias': g.numIncidente,
      });
    }

    // 🔹 Texto del periodo
    final periodoTexto =
        "${DateFormat('dd/MM/yyyy').format(inicioPeriodo)} - ${DateFormat('dd/MM/yyyy').format(finPeriodo)}";

    // Generar el PDF con CustomReport
    return await CustomReportGeneral.build(
      titulo: "Listado General de Garantías",
      periodo: periodoTexto, // 👈 nuevo campo
      data: datos,
    );
  }
}
