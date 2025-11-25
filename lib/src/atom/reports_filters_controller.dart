import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class ReportFiltersController extends GetxController {
  final wc = Get.find<WarrantyListController>();

  // -------------------------------
  // 🔵 SEMANAL (EN PROCESO)
  // -------------------------------
  Future<void> cargarSemanalEnProceso(int semana, int anio) async {
    DateTime inicio = DateTime(
      anio,
      1,
      1,
    ).add(Duration(days: (semana - 1) * 7));
    DateTime fin = inicio.add(const Duration(days: 6));

    try {
      final snap = await FirebaseFirestore.instance
          .collection('Garantias')
          .where(
            'FechaEntrada',
            isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
          )
          .where('FechaEntrada', isLessThanOrEqualTo: Timestamp.fromDate(fin))
          .where('Estado', isEqualTo: 1)
          .get();

      WarrantyListController.listaReportes.value = snap.docs
          .map((d) => Warranty.fromJson(d.data()))
          .toList();
    } catch (e) {
      WarrantyListController.listaReportes.value = [];
      print("Error semanal: $e");
    }
  }

  // -------------------------------
  // 🟢 QUINCENAL (GENERAL)
  // -------------------------------
  Future<void> cargarQuincenal(int quincena, int mes, int anio) async {
    DateTime inicio;
    DateTime fin;

    if (quincena == 1) {
      inicio = DateTime(anio, mes, 1);
      fin = DateTime(anio, mes, 15);
    } else {
      inicio = DateTime(anio, mes, 16);
      fin = DateTime(anio, mes + 1, 1).subtract(const Duration(days: 1));
    }

    await _cargarRangoGeneral(inicio, fin);
  }

  // -------------------------------
  // 🟡 MENSUAL (REINCIDENCIAS)
  // -------------------------------
  Future<void> cargarMensual(int mes, int anio) async {
    DateTime inicio = DateTime(anio, mes, 1);
    DateTime fin = DateTime(anio, mes + 1, 1).subtract(const Duration(days: 1));

    await _cargarRangoGeneral(inicio, fin);

    // luego filtras
    WarrantyListController.listaReportes.value = WarrantyListController
        .listaReportes
        .where((g) => g.numIncidente > 0)
        .toList();
  }

  // -------------------------------
  // 🟣 TRIMESTRAL (TOP 5 MÁS ANTIGUAS)
  // -------------------------------
  Future<void> cargarTrimestral(int trimestre, int anio) async {
    DateTime inicio;
    DateTime fin;

    switch (trimestre) {
      case 1:
        inicio = DateTime(anio, 1, 1);
        fin = DateTime(anio, 3, 31);
        break;
      case 2:
        inicio = DateTime(anio, 4, 1);
        fin = DateTime(anio, 6, 30);
        break;
      case 3:
        inicio = DateTime(anio, 7, 1);
        fin = DateTime(anio, 9, 30);
        break;
      default:
        inicio = DateTime(anio, 10, 1);
        fin = DateTime(anio, 12, 31);
        break;
    }

    await _cargarRangoGeneral(inicio, fin);

    // Seleccionar solo las 5 más antiguas
    WarrantyListController.listaReportes.sort(
      (a, b) => a.fechaEntrada.compareTo(b.fechaEntrada),
    );
    WarrantyListController.listaReportes.value = WarrantyListController
        .listaReportes
        .take(5)
        .toList();
  }

  // -------------------------------
  // 🔸 Función general para todos
  // -------------------------------
  Future<void> _cargarRangoGeneral(DateTime inicio, DateTime fin) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Garantias')
          .where(
            'FechaEntrada',
            isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
          )
          .where('FechaEntrada', isLessThanOrEqualTo: Timestamp.fromDate(fin))
          .get();

      WarrantyListController.listaReportes.value = snap.docs
          .map((d) => Warranty.fromJson(d.data()))
          .toList();
    } catch (e) {
      WarrantyListController.listaReportes.value = [];
      print("Error cargar rango: $e");
    }
  }
}
