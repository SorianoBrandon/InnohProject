import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:innohproject/src/custom/custom_report.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';

class ReportTop5Antiguas {
  static Future<pw.Document> build() async {
    final garantias = WarrantyListController.listaReportes;

    // Filtrar solo las garantías en estado 1
    final enProceso = garantias.where((g) => g.estado == 1).toList();

    // Ordenar por fecha de entrada (más antiguas primero)
    enProceso.sort((a, b) => a.fechaEntrada.compareTo(b.fechaEntrada));

    // Tomar solo las 5 primeras
    final top5 = enProceso.take(5).toList();

    final datos = <Map<String, dynamic>>[];

    for (int i = 0; i < top5.length; i++) {
      final g = top5[i];
      final diasTranscurridos = DateTime.now()
          .difference(g.fechaEntrada)
          .inDays;
      final fechaEntrada = DateFormat(
        'dd/MM/yyyy',
      ).format(g.fechaEntrada.toLocal());
      final fechaVenc = DateFormat(
        'dd/MM/yyyy',
      ).format(g.fechaVencimiento.toLocal());

      datos.add({
        'id': g.dni + g.ns,
        'producto': g.nombrePr,
        'cliente': g.nombreCl,
        'fechaEntrada': fechaEntrada,
        'fechaVencimiento': fechaVenc,
        'estado': 'Sin completar',
        'diasTranscurridos': diasTranscurridos,
      });
    }

    return await CustomReport.build(
      titulo: "Top 5 Garantías Más Antiguas en Proceso",
      data: datos,
    );
  }
}
