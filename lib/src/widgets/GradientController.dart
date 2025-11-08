import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GradienteController extends GetxController {
  final Rx<Alignment> inicio = Alignment.topLeft.obs;
  final Rx<Alignment> fin = Alignment.bottomRight.obs;

  void animarGradiente() {
    Future.delayed(const Duration(seconds: 8), () {
      inicio.value = inicio.value == Alignment.topLeft
          ? Alignment.bottomRight
          : Alignment.topLeft;
      fin.value = fin.value == Alignment.bottomRight
          ? Alignment.topLeft
          : Alignment.bottomRight;
      animarGradiente(); // Repetir animación
    });
  }

  @override
  void onInit() {
    super.onInit();
    animarGradiente();
  }
}
