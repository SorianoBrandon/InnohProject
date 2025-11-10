import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/warrantycontroller.dart';
import 'package:intl/intl.dart';

//no me preguntes ni madres de esto,nomas me canse de escribir la garantias a mano
class GarantiaFormModal extends StatelessWidget {
  final String infoUser;
  const GarantiaFormModal({Key? key, required this.infoUser}) : super(key: key);

  Future<void> _pickDate(BuildContext context, Warrantycontroller c) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: c.fechaVenc.value ?? now,
      firstDate: now.subtract(const Duration(days: 365 * 5)),
      lastDate: now.add(const Duration(days: 365 * 10)),
    );
    if (picked != null) c.setFechaVenc(picked);
  }

  @override
  Widget build(BuildContext context) {
    final Warrantycontroller c = Get.find();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nueva Garantía', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Campos
              TextField(
                controller: c.contCodigoProducto,
                decoration: const InputDecoration(labelText: 'CodigoProducto'),
              ),
              TextField(
                controller: c.contDNI,
                decoration: const InputDecoration(labelText: 'DNI'),
              ),
              TextField(
                controller: c.contNS,
                decoration: const InputDecoration(labelText: 'NS'),
              ),
              TextField(
                controller: c.contNFactura,
                decoration: const InputDecoration(labelText: 'NFactura'),
              ),
              TextField(
                controller: c.contNumIncidente,
                decoration: const InputDecoration(labelText: 'NumIncidente'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Estado + Fecha
              Row(
                children: [
                  const Text('Estado:'),
                  const SizedBox(width: 12),
                  Obx(() => DropdownButton<int>(
                        value: c.estado.value,
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('En proceso')),
                          DropdownMenuItem(value: 1, child: Text('Completado')),
                          DropdownMenuItem(value: 2, child: Text('Rechazado')),
                        ],
                        onChanged: (v) => c.setEstado(v ?? 0),
                      )),
                  const Spacer(),
                  Obx(() {
                    final fecha = c.fechaVenc.value;
                    return TextButton.icon(
                      onPressed: () => _pickDate(context, c),
                      icon: const Icon(Icons.date_range),
                      label: Text(fecha == null ? 'Elegir Fecha' : DateFormat('dd/MM/yyyy').format(fecha)),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              // Mensaje de validacion/estado
              Obx(() => c.mensaje.value.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(c.mensaje.value, style: const TextStyle(color: Colors.red)),
                    )),

              // Boton Guardar
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: c.saving.value
                          ? null
                          : () async {
                              await c.guardarGarantia(infoUser: infoUser);
                              if (c.mensaje.value == 'Garantía creada' || c.mensaje.value == 'Garantía actualizada') {
                                c.limpiar();
                                Navigator.of(context).pop();
                              }
                            },
                      child: c.saving.value ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white)) : const Text('Guardar'),
                    )),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
