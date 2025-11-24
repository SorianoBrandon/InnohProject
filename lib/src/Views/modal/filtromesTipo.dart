import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/grftable_mdl.dart';
import 'package:innohproject/src/atom/grf/grf_pmarcascontroller.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';

class FiltroGarantiasPorTipoModal extends StatefulWidget {
  const FiltroGarantiasPorTipoModal({super.key});

  @override
  State<FiltroGarantiasPorTipoModal> createState() =>
      _FiltroGarantiasPorTipoModalState();
}

class _FiltroGarantiasPorTipoModalState
    extends State<FiltroGarantiasPorTipoModal> {
  final listctrl = Get.find<WarrantyListController>();
  int anioSeleccionado = DateTime.now().year;
  int? mesSeleccionado;
  bool usarTodas = true; // por defecto checkeado
  String? tipoSeleccionado;

  final List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  List<String> tiposDisponibles = [];

  @override
  void initState() {
    super.initState();
    cargarTipos();
  }

  Future<void> cargarTipos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('TipoProducto')
        .get();
    setState(() {
      tiposDisponibles = snapshot.docs
          .map((doc) => doc['Tipo'] as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Seleccione Año, Mes y Tipo de Producto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Scroll infinito de años
          IgnorePointer(
            ignoring: usarTodas,
            child: Opacity(
              opacity: usarTodas ? 0.4 : 1,
              child: SizedBox(
                height: 120,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  perspective: 0.005,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      anioSeleccionado = 2000 + index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final year = 2000 + index;
                      return Center(
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: year == anioSeleccionado
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: year == anioSeleccionado
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ComboBox de meses
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mes',
            ),
            value: mesSeleccionado,
            items: List.generate(meses.length, (index) {
              final numeroMes = index + 1;
              final nombreMes = meses[index];
              return DropdownMenuItem<int>(
                value: numeroMes,
                child: Text(nombreMes),
              );
            }),
            onChanged: usarTodas
                ? null
                : (value) {
                    setState(() {
                      mesSeleccionado = value;
                    });
                  },
          ),

          const SizedBox(height: 16),

          // Checkbox
          CheckboxListTile(
            title: const Text('Utilizar todas las garantías'),
            value: usarTodas,
            onChanged: (value) {
              setState(() {
                usarTodas = value ?? false;
              });
            },
          ),

          const SizedBox(height: 16),

          // ComboBox de tipos de productos (obligatorio)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tipo de Producto',
            ),
            value: tipoSeleccionado,
            items: tiposDisponibles.map((t) {
              return DropdownMenuItem(value: t, child: Text(t));
            }).toList(),
            onChanged: (value) {
              setState(() {
                tipoSeleccionado = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Botón
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(EnvColors.azulito),
              ),
              onPressed: () async {
                if (tipoSeleccionado == null) {
                  WarningSnackbar.show(context, "Debe seleccionar un tipo.");
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                if (usarTodas) {
                  await listctrl.listaGenGarantias();
                  final datos = await GrfPmarcascontroller()
                      .generarDatosBarraPorTipo(tipoSeleccionado!);
                  final marcas = GrfPmarcascontroller.marcas;
                  Navigator.of(context).pop();
                  GraficaTablaModal.mostrar(
                    context,
                    datos: datos,
                    marcas: marcas,
                    titulo: "Garantias por Tipo de Producto",
                    emitidoPor: CurrentLog.employ!.name,
                    subtitulo: "Reporte Tipo ${tipoSeleccionado!}",
                    descripcion:
                        "Este grafico muestra una estadística sobre el porcentaje de fallo de un solo tipo producto entre todas las marcas en función de las garantías seleccionadas.",
                  );
                } else {
                  if (mesSeleccionado == null) {
                    Navigator.of(context).pop();
                    WarningSnackbar.show(context, "Debe seleccionar un mes.");
                    return;
                  }
                  await listctrl.cargarMensual(
                    mesSeleccionado!,
                    anioSeleccionado,
                  );
                  final datos = await GrfPmarcascontroller()
                      .generarDatosBarraPorTipo(tipoSeleccionado!);
                  final marcas = GrfPmarcascontroller.marcas;
                  Navigator.of(context).pop();
                  GraficaTablaModal.mostrar(
                    context,
                    datos: datos,
                    marcas: marcas,
                    titulo: "Garantias por Tipo de Producto",
                    emitidoPor: CurrentLog.employ!.name,
                    subtitulo:
                        "Reporte Tipo ${tipoSeleccionado!}\n" +
                        "Mes de ${meses[mesSeleccionado! - 1]} año $anioSeleccionado",
                    descripcion:
                        "Este grafico muestra una estadística sobre el porcentaje de fallo de un solo tipo producto entre todas las marcas en función de las garantías seleccionadas.",
                  );
                }
              },
              child: const Text(
                'Generar Gráfico',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
