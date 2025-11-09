import 'package:get/get.dart';

class LoginSwitchController extends GetxController {
  RxBool isEmpleado = false.obs;

  void toggleLog() => isEmpleado.value = !isEmpleado.value;
}
