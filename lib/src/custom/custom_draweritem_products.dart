import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/product_mdl.dart';
import 'package:innohproject/src/atom/productcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemProducto(BuildContext context) {
  return DrawerItem(
    icon: Icons.inventory_2_outlined,
    title: "Productos",
    color: EnvColors.verdete,
    onTap: () async {
      Navigator.of(context).pop();
      Get.put(ProductController());
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const ProductMdl(),
      );
      if (Get.isRegistered<ProductController>()) {
        Get.delete<ProductController>();
      }
    },
  );
}
