import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantylistcontroller.dart';
import 'package:innohproject/src/models/mdl_warranty.dart';

class WarrantyTable extends StatefulWidget {
  const WarrantyTable({super.key});

  @override
  State<WarrantyTable> createState() => _WarrantyTableState();
}

class _WarrantyTableState extends State<WarrantyTable> {
  final controller = Get.find<WarrantyListController>();

  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.listaGgraficas.isEmpty) {
        return const Center(child: Text("No hay garantías registradas"));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: const Text(
                  "Garantías Evaluadas",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                // 👈 ocupa todo el alto restante
                child: Scrollbar(
                  controller: _verticalController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    scrollDirection: Axis.vertical,
                    child: Scrollbar(
                      controller: _horizontalController,
                      thumbVisibility: true,
                      notificationPredicate: (notif) =>
                          notif.metrics.axis == Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey.shade200,
                          ),
                          columns: const [
                            DataColumn(label: Text("DNI")),
                            DataColumn(label: Text("Cliente")),
                            DataColumn(label: Text("Factura")),
                            DataColumn(label: Text("Código Prod.")),
                            DataColumn(label: Text("Producto")),
                            DataColumn(label: Text("Marca")),
                            DataColumn(label: Text("Serie")),
                            DataColumn(label: Text("Fecha Venta")),
                            DataColumn(label: Text("Fecha Venc.")),
                          ],
                          rows: controller.listaGgraficas.map((Warranty g) {
                            return DataRow(
                              cells: [
                                DataCell(Text(g.dni)),
                                DataCell(Text(g.nombreCl)),
                                DataCell(Text(g.nFactura)),
                                DataCell(Text(g.codigoProducto)),
                                DataCell(Text(g.nombrePr)),
                                DataCell(Text(g.marca)),
                                DataCell(Text(g.ns)),
                                DataCell(
                                  Text(
                                    g.fechaEntrada.toLocal().toString().split(
                                      " ",
                                    )[0],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    g.fechaVencimiento
                                        .toLocal()
                                        .toString()
                                        .split(" ")[0],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
