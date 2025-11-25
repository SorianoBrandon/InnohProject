import 'package:get/get.dart';
import 'package:innohproject/src/atom/reports_filters_controller.dart';
import 'package:innohproject/src/custom/report generators/procesos_report.dart';
import 'package:innohproject/src/custom/report generators/general_report.dart';
import 'package:innohproject/src/custom/report generators/reincidencias_report.dart';
import 'package:innohproject/src/custom/report generators/top5_report.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportLauncher {
  static final filters = Get.find<ReportFiltersController>();

  // -----------------------
  // 🔵 REPORTES SEMANALES
  // -----------------------
  static Future<pw.Document> semanal(int semana, int anio) async {
    await filters.cargarSemanalEnProceso(semana, anio);
    return await ProcesosReport.build();
  }

  // -----------------------
  // 🟢 REPORTES QUINCENALES
  // -----------------------
  static Future<pw.Document> quincenal(int quincena, int mes, int anio) async {
    await filters.cargarQuincenal(quincena, mes, anio);
    return await GeneralReport.build();
  }

  // -----------------------
  // 🟡 REPORTES MENSUALES
  // -----------------------
  static Future<pw.Document> mensual(int mes, int anio) async {
    await filters.cargarMensual(mes, anio);
    return await ReincidenciasReport.build();
  }

  // -----------------------
  // 🟣 REPORTES TRIMESTRALES
  // -----------------------
  static Future<pw.Document> trimestral(int tri, int anio) async {
    await filters.cargarTrimestral(tri, anio);
    return await ReportTop5Antiguas.build();
  }
}
