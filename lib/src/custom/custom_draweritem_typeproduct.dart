import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/modal/type_mdl.dart';
import 'package:innohproject/src/atom/typecontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemTypeProduct(BuildContext context) {
  return DrawerItem(
            icon: Icons.category_outlined,
            title: "Tipos de Productos",
            color: EnvColors.azulito,
            onTap: () {
              context.pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  Get.put(TypeController());
                  return TypeMdl();
                },
              ).then((_) => Get.delete<TypeController>());
            },
          );
}