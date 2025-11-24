import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/grftable_mdl.dart';
import 'package:innohproject/src/atom/grf/grf_mproductoscontroller.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';

class FiltroGarantiasPorMarcaModal extends StatefulWidget {
  const FiltroGarantiasPorMarcaModal({super.key});

  @override
  State<FiltroGarantiasPorMarcaModal> createState() =>
      _FiltroGarantiasPorMarcaModalState();
}

class _FiltroGarantiasPorMarcaModalState
    extends State<FiltroGarantiasPorMarcaModal> {
  final listctrl = Get.find<WarrantyListController>();
  int anioSeleccionado = DateTime.now().year;
  int? mesSeleccionado;
  bool usarTodas = true; // por defecto checkeado
  String? marcaSeleccionada;

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

  List<String> marcasDisponibles = [];

  @override
  void initState() {
    super.initState();
    cargarMarcas();
  }

  Future<void> cargarMarcas() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Marcas')
        .get();
    setState(() {
      marcasDisponibles = snapshot.docs
          .map((doc) => doc['Brand'] as String)
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
            'Seleccione Año, Mes y Marca',
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

          // ComboBox de marcas (obligatorio)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Marca',
            ),
            value: marcaSeleccionada,
            items: marcasDisponibles.map((m) {
              return DropdownMenuItem(value: m, child: Text(m));
            }).toList(),
            onChanged: (value) {
              setState(() {
                marcaSeleccionada = value;
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
                if (marcaSeleccionada == null) {
                  WarningSnackbar.show(context, "Debe seleccionar una marca.");
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                if (usarTodas) {
                  if (marcaSeleccionada == null) {
                    Navigator.of(context).pop();
                    WarningSnackbar.show(
                      context,
                      "Debe seleccionar una marca.",
                    );
                    return;
                  } else {
                    await listctrl.listaGenGarantias();
                    final datos = await GrfMproductoscontroller()
                        .generarDatosBarraPorTipo(marcaSeleccionada!);
                    final tipos = GrfMproductoscontroller.tipos;
                    Navigator.of(context).pop();
                    GraficaTablaModal.mostrar(
                      context,
                      datos: datos,
                      marcas: tipos,
                      titulo: "Garantias por Marca",
                      emitidoPor: CurrentLog.employ!.name,
                      subtitulo: "Reporte Total Marca ${marcaSeleccionada!}",
                      descripcion:
                          "Este porcentaje muestra una estadistica sobre el fallo de todos los productos de una marca en función de todas las garantías seleccionadas.",
                    );
                  }
                } else {
                  if (mesSeleccionado == null) {
                    Navigator.of(context).pop();
                    WarningSnackbar.show(context, "Debe seleccionar un mes.");
                    return;
                  }
                  if (marcaSeleccionada == null) {
                    Navigator.of(context).pop();
                    WarningSnackbar.show(
                      context,
                      "Debe seleccionar una marca.",
                    );
                    return;
                  }
                  await listctrl.cargarMensual(
                    mesSeleccionado!,
                    anioSeleccionado,
                  );
                  final datos = await GrfMproductoscontroller()
                      .generarDatosBarraPorTipo(marcaSeleccionada!);
                  final tipos = GrfMproductoscontroller.tipos;
                  Navigator.of(context).pop();
                  GraficaTablaModal.mostrar(
                    context,
                    datos: datos,
                    titulo: "Garantias por Marca",
                    marcas: tipos,
                    emitidoPor: CurrentLog.employ!.name,
                    subtitulo:
                        "Report Mensual Marca ${marcaSeleccionada!}\n" +
                        "Mes de ${meses[mesSeleccionado! - 1]} año $anioSeleccionado",
                    descripcion:
                        "Este porcentaje muestra una estadistica sobre el fallo de todos los productos de una marca en función de las garantías seleccionadas.",
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
