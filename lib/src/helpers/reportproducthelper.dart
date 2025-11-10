import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> ListadoProductosEnProceso({
  int inventDaysMax = 30,
  int seed = 42,
}) async {
  final firestore = FirebaseFirestore.instance;

  // Query: solo garantias con Estado == 0 (En proceso)
  final querySnap = await firestore.collection('Garantias').where('Estado', isEqualTo: 0).get();
  final docs = querySnap.docs;

  final List<Map<String, dynamic>> reporte = [];
  final rnd = Random(seed);
  final formatter = DateFormat('dd/MM/yyyy');
  final ahora = DateTime.now();

  // Caches para evitar múltiples lecturas del mismo documento
  final Map<String, String> clienteCache = {};
  final Map<String, Map<String, dynamic>> productoCache = {};

  for (var i = 0; i < docs.length; i++) {
    final qDoc = docs[i];
    final data = qDoc.data();

    // Autonumerado
    final numero = 'GRT-${(i + 1).toString().padLeft(4, '0')}';

    // CodigoProducto desde el documento de garantia
    final codigoProductoRaw = (data['CodigoProducto'] ?? '').toString().trim();

    // Obtener info de producto (cacheado)
    String codigoProducto = codigoProductoRaw;
    String nombreProducto = codigoProductoRaw.isEmpty ? 'Sin código' : codigoProductoRaw;
    String proveedor = 'Sin marca';
    if (codigoProductoRaw.isNotEmpty) {
      if (productoCache.containsKey(codigoProductoRaw)) {
        final p = productoCache[codigoProductoRaw]!;
        nombreProducto = (p['Descripcion'] ?? p['Nombre'] ?? nombreProducto).toString();
        proveedor = (p['Marca'] ?? p['Proveedor'] ?? proveedor).toString();
      } else {
        try {
          final pSnap = await firestore.collection('Productos').doc(codigoProductoRaw).get();
          if (pSnap.exists) {
            final p = pSnap.data()!;
            productoCache[codigoProductoRaw] = p;
            nombreProducto = (p['Descripcion'] ?? p['Nombre'] ?? nombreProducto).toString();
            proveedor = (p['Marca'] ?? p['Proveedor'] ?? proveedor).toString();
          }
        } catch (_) {
          // ignore and keep defaults
        }
      }
    }

    // DNI y nombre cliente (cacheado)
    final dniRaw = (data['DNI'] ?? '').toString().trim();
    String nombreCliente = 'Sin nombre';
    if (dniRaw.isNotEmpty) {
      if (clienteCache.containsKey(dniRaw)) {
        nombreCliente = clienteCache[dniRaw]!;
      } else {
        try {
          final cSnap = await firestore.collection('Clientes').doc(dniRaw).get();
          if (cSnap.exists) {
            final c = cSnap.data();
            nombreCliente = (c?['Name'] ?? c?['Nombre'] ?? c?['name'] ?? 'Sin nombre').toString();
          }
        } catch (_) {
          // ignore
        }
        clienteCache[dniRaw] = nombreCliente;
      }
    }

    // Fecha ingreso: preferir campos explícitos si existen
    DateTime? fechaIngreso;
    final fRaw = data['FechaIngreso'] ?? data['FechaCreacion'] ?? data['FechaIngresoTimestamp'] ?? data['FechaVencimiento'];
    if (fRaw is Timestamp) {
      fechaIngreso = fRaw.toDate();
    } else if (fRaw is DateTime) {
      fechaIngreso = fRaw;
    } else if (fRaw is String) {
      try {
        fechaIngreso = DateTime.parse(fRaw);
      } catch (_) {
        fechaIngreso = null;
      }
    }

    // Si no hay fecha explícita, fallback determinista usando seed
    if (fechaIngreso == null) {
      final diasAtras = rnd.nextInt(inventDaysMax + 1); // 0..inventDaysMax
      fechaIngreso = ahora.subtract(Duration(days: diasAtras));
    }

    final fechaIngresoStr = formatter.format(fechaIngreso);
    final diasTranscurridos = ahora.difference(fechaIngreso).inDays;

    // Estado: manejar nulos y mapear a texto
    final estadoRaw = data['Estado'];
    int estadoInt;
    if (estadoRaw is int) {
      estadoInt = estadoRaw;
    } else if (estadoRaw is String) {
      estadoInt = int.tryParse(estadoRaw) ?? 0;
    } else {
      estadoInt = 0; // por defecto En proceso
    }
    final estadoTexto = {0: 'En proceso', 1: 'Completado', 2: 'Rechazado'}[estadoInt] ?? 'Desconocido';

    // Agregar fila al reporte (añade otros campos si tu PDF los necesita)
    reporte.add({
      'numero': numero,
      'codigoProducto': codigoProducto,
      'producto': nombreProducto,
      'proveedor': proveedor,
      'cliente': nombreCliente,
      'fechaIngreso': fechaIngresoStr,
      'diasTranscurridos': diasTranscurridos,
      'estadoActual': estadoTexto,
    });
  }

  return reporte;
}
