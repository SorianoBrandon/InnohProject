import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/grftable_mdl.dart';
import 'package:innohproject/src/atom/grf/grf_marcascontroller.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_colors.dart';
import 'package:innohproject/src/helpers/snackbars.dart';

class FiltroGarantiasModal extends StatefulWidget {
  const FiltroGarantiasModal({super.key});

  @override
  State<FiltroGarantiasModal> createState() => _FiltroGarantiasModalState();
}

class _FiltroGarantiasModalState extends State<FiltroGarantiasModal> {
  final listctrl = Get.find<WarrantyListController>();
  int anioSeleccionado = DateTime.now().year;
  int? mesSeleccionado;
  bool usarTodas = true; // 👈 por defecto checkeado

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Seleccione el Año y Mes para Filtrar las Garantías',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Scroll infinito de años (deshabilitado si usarTodas = true)
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

          // ComboBox de meses (deshabilitado si usarTodas = true)
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

          // Botón
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(EnvColors.azulito),
              ),
              onPressed: () async {
                if (usarTodas) {
                  await listctrl.listaGenGarantias();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final datos = await GrfMarcasController().generarDatosBarra();
                  final marcas = GrfMarcasController.marcas;

                  Navigator.of(context).pop(); // cierra el loading

                  GraficaTablaModal.mostrar(
                    context,
                    datos: datos,
                    marcas: marcas,
                    titulo: "Garantias entre Marcas",
                    emitidoPor: CurrentLog.employ!.name,
                    subtitulo: "Reporte Total",
                    descripcion:
                        "Este grafico muestra una estadística sobre el porcentaje de fallo de los productos de todas las marcas en función de las garantías seleccionadas.",
                  );
                } else {
                  if (mesSeleccionado == null) {
                    WarningSnackbar.show(
                      context,
                      "Debe seleccionar un mes para filtrar.",
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  await listctrl.cargarMensual(
                    mesSeleccionado!,
                    anioSeleccionado,
                  );
                  final datos = await GrfMarcasController().generarDatosBarra();
                  final marcas = GrfMarcasController.marcas;

                  Navigator.of(context).pop(); // cierra el loading

                  GraficaTablaModal.mostrar(
                    context,
                    datos: datos,
                    marcas: marcas,
                    titulo: "Garantias entre Marcas",
                    emitidoPor: CurrentLog.employ!.name,
                    subtitulo:
                        "Reporte Mensual\n" +
                        "Mes de ${meses[mesSeleccionado! - 1]} año $anioSeleccionado",
                    descripcion:
                        "Este grafico muestra una estadística sobre el porcentaje de fallo de los productos de todas las marcas en función de las garantías seleccionadas.",
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
