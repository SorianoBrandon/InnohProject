import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//Sale modificado pero como no subo al git nunca se me quita lo modificado al guardar xd
//asi que supongo que esta igual que el dia de la defensa,no deberia haber cambio alguno

Future<List<Map<String, dynamic>>> listadoReincidentes() async {
  final firestore = FirebaseFirestore.instance;

  final garantiasSnap = await firestore
      .collection('Garantias')
      .where('NumInsidente', isGreaterThan: 0)
      .get();

  final productosSnap = await firestore.collection('Productos').get();
  final productosMap = {
    for (var doc in productosSnap.docs) doc.id: doc.data(), 
  };

  final hoy = DateFormat('dd/MM/yyyy').format(DateTime.now());

  return garantiasSnap.docs.map((doc) {
    final g = doc.data();
    final codigo = g['CodigoProducto'] ?? '';
    final productoData = productosMap[codigo];

    final nivel = g['NumInsidente'] > 4
        ? 'Alto'
        : (g['NumInsidente'] >= 2 ? 'Medio' : 'Bajo');

    return {
      'producto': productoData?['Descripcion'] ?? 'Desconocido',
      'marca': productoData?['Marca'] ?? 'Desconocida',
      'fecha': hoy,
      'nivel': nivel,
      'problema': g['problema'] ?? 'Sin especificar',
    };
  }).toList();
}
