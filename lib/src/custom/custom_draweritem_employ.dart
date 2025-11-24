import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/modal/employee_mdl.dart';
import 'package:innohproject/src/atom/employcontroller.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemEmploy(BuildContext context) {
  return DrawerItem(
    icon: Icons.work_outline_rounded,
    title: "Empleados",
    color: EnvColors.verdete,
    onTap: () {
      context.pop();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          Get.put(Employcontroller());
          return EmployeeMdl();
        },
      ).then((_) => Get.delete<Employcontroller>());
    },
  );
}
