import 'package:flutter/material.dart';
import 'package:innohproject/src/custom/custom_draweritem_brands.dart';
import 'package:innohproject/src/custom/custom_draweritem_clients.dart';
import 'package:innohproject/src/custom/custom_draweritem_employ.dart';
import 'package:innohproject/src/custom/custom_draweritem_graph.dart';
import 'package:innohproject/src/custom/custom_draweritem_logout.dart';
import 'package:innohproject/src/custom/custom_draweritem_reports.dart';
import 'package:innohproject/src/custom/custom_draweritem_typeproduct.dart';
import 'package:innohproject/src/custom/custom_draweritem_warranty.dart';
import 'package:innohproject/src/env/current_log.dart';
import 'package:innohproject/src/env/env_Colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: EnvColors.fondo,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [EnvColors.azulito, EnvColors.azulote],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    child: Text(
                      CurrentLog.employ!.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    CurrentLog.employ!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${CurrentLog.employ!.user}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(
                        CurrentLog.employ!.phone,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.white70, thickness: 2),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      CurrentLog.employ!.role.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          drawerItemCliente(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemEmploy(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemBrands(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemTypeProduct(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemReports(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemGraphs(context),
          CurrentLog.employ!.role == 'Vendedor'
              ? SizedBox()
              : drawerItemWarranty(context),
          drawerItemLogout(context),
        ],
      ),
    );
  }
}
