import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class WarrantyListController extends GetxController {
  final listaGarantias = <Warranty>[].obs;
  final garantiaSeleccionada = Rxn<Warranty>();
  final garantiaId = RxnString();

  void listaGenGarantias() {
    listaGarantias.bindStream(
      FirebaseFirestore.instance.collection('Garantias').snapshots().map((
        snapshot,
      ) {
        return snapshot.docs
            .map((doc) {
              try {
                return Warranty.fromJson(doc.data());
              } catch (e) {
                print("Error al convertir garantía: $e");
                return null;
              }
            })
            .whereType<Warranty>()
            .toList();
      }),
    );
  }

  void listaGarProceso() {
    listaGarantias.bindStream(
      FirebaseFirestore.instance
          .collection('Garantias')
          .where('Estado', isEqualTo: 1)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  try {
                    return Warranty.fromJson(doc.data());
                  } catch (e) {
                    print("Error al convertir garantía: $e");
                    return null;
                  }
                })
                .whereType<Warranty>()
                .toList();
          }),
    );
  }

  void listaGarDni(String dni) {
    listaGarantias.bindStream(
      FirebaseFirestore.instance
          .collection('Garantias')
          .where('DNI', isEqualTo: dni)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  try {
                    return Warranty.fromJson(doc.data());
                  } catch (e) {
                    print("Error al convertir garantía: $e");
                    return null;
                  }
                })
                .whereType<Warranty>()
                .toList();
          }),
    );
  }

  /// 🔹 Mensual: recibe mes y año
  Future<void> cargarMensual(int mes, int anio) async {
    DateTime inicio = DateTime(anio, mes, 1);
    DateTime fin = DateTime(anio, mes + 1, 1).subtract(const Duration(days: 1));

    await _cargarPorRango(inicio, fin);
  }

  /// 🔹 Quincenal: recibe número de quincena (1 o 2) y año
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

    await _cargarPorRango(inicio, fin);
  }

  /// 🔹 Semanal: recibe número de semana y año
  Future<void> cargarSemanal(int semana, int anio) async {
    // Calcular primer día del año
    DateTime inicioAnio = DateTime(anio, 1, 1);

    // Día inicial de la semana (ISO: semana 1 empieza en el primer lunes del año)
    DateTime inicio = inicioAnio.add(Duration(days: (semana - 1) * 7));

    // Fin de la semana (7 días después)
    DateTime fin = inicio.add(const Duration(days: 6));

    await _cargarPorRango(inicio, fin);
  }

  /// 🔹 Personalizado: recibe fecha inicio y fecha fin
  Future<void> cargarPorRangoFechas(DateTime inicio, DateTime fin) async {
    await _cargarPorRango(inicio, fin);
  }

  /// 🔹 Función interna para cargar por rango
  Future<void> _cargarPorRango(DateTime inicio, DateTime fin) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Garantias')
        .where(
          'FechaEntrada',
          isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
        )
        .where('FechaEntrada', isLessThanOrEqualTo: Timestamp.fromDate(fin))
        .get();

    final garantiasTemp = snapshot.docs
        .map((doc) {
          try {
            return Warranty.fromJson(doc.data());
          } catch (e) {
            print("Error al convertir garantía: $e");
            return null;
          }
        })
        .whereType<Warranty>()
        .toList();

    listaGarantias.value = garantiasTemp;
  }

  void seleccionarGarantia(Warranty g, String id) {
    if (garantiaId.value == id) {
      garantiaSeleccionada.value = null;
      garantiaId.value = null;
    } else {
      garantiaSeleccionada.value = g;
      garantiaId.value = id;
    }
  }
}
