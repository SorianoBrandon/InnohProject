import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/atom/productcontroller.dart';
import 'package:innohproject/src/models/mdl_product.dart';

class ProductMdl extends StatelessWidget {
  const ProductMdl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller.cont_codigo,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              decoration: const InputDecoration(labelText: "Código"),
              onSubmitted: (_) => controller.buscarProducto(context),
            ),
            TextField(
              controller: controller.cont_descripcion,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: controller.cont_marca,
              decoration: const InputDecoration(labelText: "Marca"),
            ),
            TextField(
              controller: controller.cont_modelo,
              decoration: const InputDecoration(labelText: "Modelo"),
            ),
            TextField(
              controller: controller.cont_tipo,
              decoration: const InputDecoration(labelText: "Tipo"),
            ),
            TextField(
              controller: controller.cont_tGarantia,
              decoration: const InputDecoration(
                labelText: "Tiempo de garantía (meses)",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  controller.guardarProducto(
                    Producto(
                      codigo: controller.cont_codigo.text.trim(),
                      descripcion: controller.cont_descripcion.text.trim(),
                      marca: controller.cont_marca.text.trim(),
                      modelo: controller.cont_modelo.text.trim(),
                      tipo: controller.cont_tipo.text.trim(),
                      tGarantia:
                          int.tryParse(controller.cont_tGarantia.text.trim()) ??
                          0,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(controller.txt_button.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
