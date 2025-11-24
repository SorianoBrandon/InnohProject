import 'package:flutter/material.dart';
import 'package:innohproject/src/env/env_Colors.dart';

Widget graphicCard({
  required BuildContext context,
  required String title,
  required int chartId,
}) {
  // Card que al hacer tap abre un modal con el gráfico
  return Card(
    color: chartId % 2 == 1 ? EnvColors.azulito : EnvColors.verdete,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart, size: 80, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
