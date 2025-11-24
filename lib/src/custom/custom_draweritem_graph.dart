import 'package:innohproject/src/Views/modal/graficas_mdl.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:flutter/material.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemGraphs(BuildContext context) {
  return DrawerItem(
    icon: Icons.pie_chart_outline,
    title: "Graficas",
    color: EnvColors.verdete,
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => GraficasdMdl(),
      );
    },
  );
}
