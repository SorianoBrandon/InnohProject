import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class WarrantyListController extends GetxController {
  final listaGarantias = <Warranty>[].obs;
  final listaGgraficas = <Warranty>[].obs;
  static final listaReportes = <Warranty>[].obs;
  final garantiaSeleccionada = Rxn<Warranty>();
  final garantiaId = RxnString();

  Future<void> listaGenGarantias() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Garantias')
          .get();

      final lista = snapshot.docs
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

      listaGgraficas.value = lista; // 👈 asigna directamente la lista
    } catch (e) {
      print("Error al cargar garantías: $e");
      listaGgraficas.value = []; // 👈 evita que quede null
    }
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

  void listaGarUser() {
    listaGarantias.bindStream(
      FirebaseFirestore.instance
          .collection('Garantias')
          .where(
            'InfoUser',
            isEqualTo: CurrentLog.employ!.user,
          ) // 👈 filtro por campo infouser
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

  Future<void> cargarMensual(int mes, int anio) async {
    DateTime inicio = DateTime(anio, mes, 1);
    DateTime fin = DateTime(anio, mes + 1, 1).subtract(const Duration(days: 1));

    await _cargarPorRango(inicio, fin);
  }

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

  Future<void> cargarSemanal(int semana, int anio) async {
    // Calcular primer día del año
    DateTime inicioAnio = DateTime(anio, 1, 1);

    // Día inicial de la semana (ISO: semana 1 empieza en el primer lunes del año)
    DateTime inicio = inicioAnio.add(Duration(days: (semana - 1) * 7));

    // Fin de la semana (7 días después)
    DateTime fin = inicio.add(const Duration(days: 6));

    await _cargarPorRango(inicio, fin);
  }

  Future<void> cargarPorRangoFechas(DateTime inicio, DateTime fin) async {
    await _cargarPorRango(inicio, fin);
  }

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

    listaGgraficas.value = garantiasTemp;
    listaReportes.value = garantiasTemp;
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
      case 4:
        inicio = DateTime(anio, 10, 1);
        fin = DateTime(anio, 12, 31);
        break;
      default:
        throw ArgumentError("El trimestre debe ser entre 1 y 4");
    }

    await _cargarPorRango(inicio, fin);
  }

  void listaCargarMasAntiguos() {
    listaReportes.bindStream(
      FirebaseFirestore.instance
          .collection('Garantias')
          .where('Estado', isEqualTo: 1) // solo en proceso
          .orderBy('FechaEntrada', descending: true) // más antiguas primero
          .limit(5)
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

  void listaGarantiasConReincidencias() {
    final filtradas = listaReportes.where((g) => g.numIncidente > 0).toList();

    listaReportes.value = filtradas;
  }
}
