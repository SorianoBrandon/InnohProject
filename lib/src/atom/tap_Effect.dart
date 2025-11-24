import 'package:flutter/material.dart';

class TapEffect extends StatefulWidget {
  final Widget child; // Widget al que se aplica el efecto
  final VoidCallback onTap; // Función que se ejecutará después del tap

  const TapEffect({Key? key, required this.child, required this.onTap})
    : super(key: key);

  @override
  _TapEffectState createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 150,
      ), // Duración completa de la animación
    );

    // Define la animación de escala
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Ejecuta la animación completa al tap
        await _controller.forward(); // Corre la animación hacia "adelante"
        await _controller.reverse(); // Regresa a su estado original
        widget.onTap(); // Llama a la función pasada
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value, // Aplica la escala animada
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
