import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EmployLogController extends GetxController {
  final cont_User = TextEditingController();
  final cont_DNI = TextEditingController();
  final cont_Password = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    cont_Password.dispose();
    cont_DNI.dispose();
    cont_User.dispose();
    super.onClose();
  }
}
