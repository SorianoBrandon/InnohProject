import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/brand_mdl.dart';
import 'package:innohproject/src/atom/brandcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemBrands(BuildContext context) {
  return DrawerItem(
    icon: Icons.branding_watermark_outlined,
    title: "Marcas",
    color: EnvColors.verdete,
    onTap: () async {
      Navigator.of(context).pop();
      Get.put(BrandController());
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const BrandMdl(),
      );
      if (Get.isRegistered<BrandController>()) {
        Get.delete<BrandController>();
      }
    },
  );
}
