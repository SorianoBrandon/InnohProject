import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class WarrantyListController extends GetxController {
  final listaGarantias = <Warranty>[].obs;
  final garantiaSeleccionada = Rxn<Warranty>();

  @override
  void onInit() {
    super.onInit();
    cargarGarantias();
  }

  void cargarGarantias() {
  FirebaseFirestore.instance.collection('Garantias').snapshots().listen((snapshot) {
    final garantiasTemp = <Warranty>[];

    for (var doc in snapshot.docs) {
      try {
        final garantia = Warranty.fromJson(doc.data());

        // Join con Productos 
        FirebaseFirestore.instance
            .collection('Productos')
            .doc(garantia.codigoProducto)
            .get()
            .then((prodDoc) {
              final descripcion = prodDoc.exists
                  ? (prodDoc.data()?['Descripcion'] ?? 'Sin descripción' )
                  : 'Sin descripción';

              garantia.descripcionProducto = descripcion;
              garantiasTemp.add(garantia);

              // Actualizar lista cada vez que se enriquece una garantía
              listaGarantias.value = List.from(garantiasTemp);
            });

      } catch (e) {
       
      }
    }

    // Si no hay join, igual muestra las garantías base
    if (snapshot.docs.isEmpty) {
      listaGarantias.value = [];
    }
  });
}

  //pa trabajar en la garantia seleccionada
  void seleccionarGarantia(Warranty g) {
    garantiaSeleccionada.value = g;
  }

}
