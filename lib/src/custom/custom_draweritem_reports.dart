import 'package:go_router/go_router.dart';
import 'package:innohproject/src/Views/modal/reportlistwarranty_mdl.dart';
import 'package:innohproject/src/env/env_Colors.dart';
import 'package:flutter/material.dart';
import 'package:innohproject/src/widgets/draweritem.dart';

DrawerItem drawerItemReports(BuildContext context) {  
return DrawerItem(
            icon: Icons.analytics_outlined,
            title: "Reportes",
            color: EnvColors.verdete,
            onTap: () {
              context.pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => ReportListWarrantyMdl(),  
              );
            },
          );

}