import 'package:flutter/material.dart';

class LogMessage extends StatelessWidget {
  const LogMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '¡Bienvenido!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Portal de Garantías',
          style: TextStyle(fontSize: 20, color: Colors.white70),
        ),
        SizedBox(height: 16),
        Text(
          'Este es su portal de reclamos. '
          'Adicional encontrará los productos que usted ha comprado en nuestra empresa. ',
          style: TextStyle(fontSize: 16, color: Colors.white60),
        ),
      ],
    );
  }
}
