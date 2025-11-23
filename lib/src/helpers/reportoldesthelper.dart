import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//Sale modificado pero como no subo al git nunca se me quita lo modificado al guardar xd
//asi que supongo que esta igual que el dia de la defensa,no deberia haber cambio alguno

Future<List<Map<String, dynamic>>> listadoTop5Antiguas({
  String fechaField = 'FechaVebcimiento', 
  String estadoPendienteField = 'Estado',
  dynamic valorEstadoPendiente = 0,
}) async {
  final firestore = FirebaseFirestore.instance;

  final garantiasSnap = await firestore
      .collection('Garantias')
      .where(estadoPendienteField, isEqualTo: valorEstadoPendiente) // filtra pendientes
      .orderBy(fechaField, descending: false)
      .limit(5)
      .get();

  if (garantiasSnap.docs.isEmpty) return [];

  final productosSnap = await firestore.collection('Productos').get();
  final productosMap = {
    for (var doc in productosSnap.docs) doc.id: doc.data(),
  };

  final hoy = DateTime.now();

  return garantiasSnap.docs.map((doc) {
    final g = doc.data();

    DateTime fechaIngreso;
    final raw = g[fechaField];
    if (raw is Timestamp) {
      fechaIngreso = raw.toDate();
    } else if (raw is String) {

      try {
        fechaIngreso = DateTime.parse(raw);
      } catch (e) {

        fechaIngreso = hoy;
      }
    } else {
      fechaIngreso = hoy;
    }

    final codigo = (g['CodigoProducto'] ?? g['codigoproducto'] ?? '').toString();
    final productoData = productosMap[codigo];

    final diasTranscurridos = hoy.difference(fechaIngreso).inDays;

    return {
      'diasTranscurridos': diasTranscurridos,
      'numGarantia': doc.id,
      'producto': productoData?['Descripcion'] ?? productoData?['descripcion'] ?? 'Desconocido',
      'marca': productoData?['Marca'] ?? productoData?['marca'] ?? 'Desconocida',
      'fechaIngreso': DateFormat('dd/MM/yyyy').format(fechaIngreso),
      'estadoActual': g['EstadoDescripcion'] ?? g['EstadoTexto'] ?? g['Estado'] ?? 'Pendiente',
      'rawGarantia': g,
    };
  }).toList();
}
