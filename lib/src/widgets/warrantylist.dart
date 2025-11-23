import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class WarrantyList extends StatelessWidget {
  final int? estadoFiltrado;
  final String? dniCliente;
  final void Function(Warranty)? onSelect;

  const WarrantyList({
    super.key,
    this.estadoFiltrado,
    this.dniCliente,
    this.onSelect,
  });


  Future<String> obtenerNombreCliente(String dni) async {
    final doc = await FirebaseFirestore.instance
        .collection('Clientes')
        .doc(dni)
        .get();
    return doc.data()?['Name'] ?? 'Cliente desconocido';
  }

  Future<String> obtenerTelefono(String dni) async {
    final doc = await FirebaseFirestore.instance
        .collection('Clientes')
        .doc(dni)
        .get();
    return doc.data()?['Phone'] ?? 'Numero desconocido';
  }


  Future<String> obtenerTipoYDescripcion(String codigoProducto) async {
  final doc = await FirebaseFirestore.instance
      .collection('Productos')
      .doc(codigoProducto)
      .get();

  final tipo = doc.data()?['Tipo'] ?? 'Tipo desconocido';
  final descripcion = doc.data()?['Descripcion'] ?? 'Producto desconocido';

  return "$tipo - $descripcion"; 
}


  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('Garantias');

    //Si hay filtro por estado
    if (estadoFiltrado != null) {
      query = query.where('Estado', isEqualTo: estadoFiltrado);
    }

    //Si hay filtro por DNI (vista cliente)
    if (dniCliente != null) {
      query = query.where('DNI', isEqualTo: dniCliente);
    }

  return StreamBuilder<QuerySnapshot>(
  stream: query.snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final garantias = snapshot.data!.docs.map((doc) {
      final w = Warranty.fromJson(doc.data() as Map<String, dynamic>);
      w.docId = doc.id; 
      return w;
    }).toList();

    if (garantias.isEmpty) {
      return const Center(child: Text('No hay garantías registradas'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: garantias.length,
      itemBuilder: (context, index) {
        final g = garantias[index]; 

        return FutureBuilder<List<String>>(
          future: Future.wait([
            obtenerTipoYDescripcion(g.codigoProducto),
            obtenerNombreCliente(g.dni),
            obtenerTelefono(g.dni),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: LinearProgressIndicator(),
              );
            }

            final tipoDescripcion  = snapshot.data![0];
            final nombreCliente = snapshot.data![1];
            final telefonoCliente = snapshot.data![2];


            // Tarjeta de garantía 
            return InkWell(
              onTap: () {
                g.tituloProducto = tipoDescripcion;
                onSelect?.call(g);// Llama al callback con la garantía seleccionada
              },
              child: Card(
                color: index % 2 == 0
                    ? EnvColors.azulote
                    : EnvColors.verdete,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoDescripcion ,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Cliente: $nombreCliente',
                          style: const TextStyle(color: Colors.white)),
                      Text('Tel: $telefonoCliente',
                          style: const TextStyle(color: Colors.white)),
                      Text('DNI: ${g.dni}',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  },
);

  }
}
