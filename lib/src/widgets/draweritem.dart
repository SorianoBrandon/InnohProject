import 'package:flutter/material.dart';
import 'package:innohproject/src/env/env_Colors.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withValues(alpha: 0.8),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: EnvColors.azulote.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.9),
                      offset: const Offset(0, 3),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
