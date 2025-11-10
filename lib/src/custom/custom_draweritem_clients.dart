import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innohproject/src/Views/modal/client_mdl.dart';
import 'package:innohproject/src/atom/clientcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemCliente(BuildContext context) {
  return DrawerItem(
    icon: Icons.people_outline_rounded,
    title: "Clientes",
    color: EnvColors.verdete,
    onTap: () async {
      Navigator.of(context).pop();
      Get.put(ClientController());
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const ClientMdl(),
      );
      if (Get.isRegistered<ClientController>()) {
        Get.delete<ClientController>();
      }
    },
  );
}
