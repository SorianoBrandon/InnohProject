import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> construirListadoGarantias() async {
  final firestore = FirebaseFirestore.instance;
  final garantias = await firestore.collection('Garantias').get();

  List<Map<String, dynamic>> reporte = [];

  // Recorre cada garantía y obtiene los datos necesarios
  for (int i = 0; i < garantias.docs.length; i++) {
    final doc = garantias.docs[i].data();
    final codigoProducto = doc['CodigoProducto'];
    final dni = doc['DNI'];
    final estado = doc['Estado'];
    final fechaVenc = (doc['FechaVencimiento'] as Timestamp).toDate();

    // Producto si coincide codigo lo saca
    final productoSnap = await firestore.collection('Productos').doc(codigoProducto).get();
    final productoData = productoSnap.data();
    final nombreProducto = productoData?['Descripcion'] ?? 'Desconocido';
    final proveedor = productoData?['Marca'] ?? 'Sin marca';

    // Cliente si coincide dni lo saca
    final clienteSnap = await firestore.collection('Clientes').doc(dni.trim()).get();//lo que me dio dolor de culo no poner ese .trim
    final clienteData = clienteSnap.data();
    final nombreCliente = clienteData?['Name'] ?? 'Sin nombre';

    // Estado textual
    final estadoTexto = switch (estado) {
      0 => 'En proceso',
      1 => 'Completado',
      2 => 'Rechazado',
      _ => 'Desconocido',
    };

    // Fecha cierre
    final fechaCierre = estado == 1 ? DateFormat('dd/MM/yyyy').format(fechaVenc) : '-';

    // Días restantes
    final diasRestantes = fechaVenc.difference(DateTime.now()).inDays;

    // Agrega al reporte
    reporte.add({
      'numero': 'GRT-${(i + 1).toString().padLeft(4, '0')}',
      'producto': nombreProducto,
      'cliente': nombreCliente,
      'proveedor': proveedor,
      'estado': estadoTexto,
      'fechaCierre': fechaCierre,
      'diasRestantes': diasRestantes,
    });
  }

  return reporte;
}
