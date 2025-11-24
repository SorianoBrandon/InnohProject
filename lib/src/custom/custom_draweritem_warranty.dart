import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/warrant_mdl.dart';
import 'package:innohproject/src/atom/warrantycontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

//no me preguntes ni madres de esto,nomas me canse de escribir la garantias a mano
DrawerItem drawerItemWarranty(BuildContext context) {
  return DrawerItem(
    icon: Icons.shield_outlined,
    title: 'Nueva Garantía',
    color: EnvColors.verdete,
    onTap: () async {
      Navigator.of(context).pop();
      Get.put(Warrantycontroller());
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => GarantiaFormModal(infoUser: 'admin'),
      ).then((_) {
        if (Get.isRegistered<Warrantycontroller>())
          Get.delete<Warrantycontroller>();
      });
    },
  );
}
