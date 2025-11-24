import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:innohproject/src/helpers/sesionhelper.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemLogout(BuildContext context) {
  return DrawerItem(
    icon: Icons.logout_outlined,
    title: "Cerrar Sesión",
    color: EnvColors.verdesote,
    onTap: () async {
      context.pop();
      await SesionHelper.borrar();
      context.go('/');
    },
  );
}
