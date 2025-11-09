import 'package:innohproject/src/widgets/logmessage.dart';
import 'package:flutter/material.dart';
import 'package:innohproject/src/widgets/GradientController.dart';
import 'package:innohproject/src/atom/switchlogcontroller.dart';
import 'package:innohproject/src/widgets/clientlog.dart';
import 'package:innohproject/src/widgets/employlog.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final sizescreen = MediaQuery.of(context).size;
    final GradienteController controller = Get.put(GradienteController());
    final loginController = Get.put(LoginSwitchController());
    final esPantallaGrande = sizescreen.width > 800;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: sizescreen.width,
              height: sizescreen.height,
              color: Color(0xFFf5f5f5),
              child: Center(
                child: SingleChildScrollView(
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(seconds: 8),
                      width: esPantallaGrande ? 800 : sizescreen.width * 0.9,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0b3f8e),
                            const Color(0xFF28a133),
                          ],
                          begin: controller.inicio.value,
                          end: controller.fin.value,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: esPantallaGrande
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/Logo.jpg',
                                        height: 90,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Spacer(),
                                    Transform.translate(
                                      offset: const Offset(0, -30),
                                      child: TextButton(
                                        onPressed: () {
                                          loginController.toggleLog();
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text('¿Empleado?'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: LogMessage()),
                                    const SizedBox(width: 32),
                                    Expanded(
                                      child: loginController.isEmpleado.value
                                          ? EmployLog()
                                          : ClientLog(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                LogMessage(),
                                const SizedBox(height: 32),
                                loginController.isEmpleado.value
                                    ? EmployLog()
                                    : ClientLog(),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: sizescreen.width,
              padding: EdgeInsets.all(50),
              color: Colors.redAccent,
              child: Center(child: Text('Pie de Pagina')),
            ),
          ],
        ),
      ),
    );
  }
}
