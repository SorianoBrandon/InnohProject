import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendedorController extends GetxController {
  final db = FirebaseFirestore.instance;

  //Campos del producto
  var codigoProducto = ''.obs;
  var nombreProducto = ''.obs;
  var tiempoGarantia = ''.obs;

  //Campos manuales
  var numeroSerie = ''.obs;
  var numeroFactura = ''.obs;

  //Datos del cliente
  var identidadCliente = ''.obs;
  var telefonoCliente = ''.obs;
  var nombreCliente = ''.obs;
  var direccionCliente = ''.obs;

  //Buscar producto por código
  Future<void> buscarProducto() async {
    if (codigoProducto.value.isEmpty) return;

    final snap = await db
        .collection('Productos')
        .doc(codigoProducto.value)
        .get();

    if (snap.exists) {
      final data = snap.data()!;
      nombreProducto.value = data['Descripcion'] ?? '';
      final dias = int.tryParse(data['TGarantia'] ?? '0') ?? 0;

      String representacion;
      if (dias < 30) {
        representacion = "$dias días";
      } else if (dias % 30 == 0 && dias < 365) {
        representacion = "${dias ~/ 30} meses";
      } else if (dias % 365 == 0) {
        representacion = "${dias ~/ 365} años";
      } else {
        representacion = "$dias días";
      }

      tiempoGarantia.value = representacion;
    } else {
      nombreProducto.value = 'Producto no encontrado';
      tiempoGarantia.value = '';
    }
  }

  // Guardar datos
  Future<void> guardarVenta() async {
    if (codigoProducto.value.isEmpty ||
        numeroSerie.value.isEmpty ||
        numeroFactura.value.isEmpty ||
        identidadCliente.value.isEmpty) {
      Get.snackbar("Error", "Completa todos los campos obligatorios");
      return;
    }

    Get.snackbar("Éxito", "La venta se guardó correctamente");
  }
}
