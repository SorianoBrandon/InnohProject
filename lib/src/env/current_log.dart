import 'package:innohproject/src/helpers/sesionhelper.dart';
import 'package:innohproject/src/models/mdl_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innohproject/src/models/mdl_employ.dart';

class CurrentLog {
  static MdlClient? client;
  static MdlEmploy? employ;
  static bool islog = false;

  static void loadLog({
    QuerySnapshot<Map<String, dynamic>>? empleado,
    QuerySnapshot<Map<String, dynamic>>? cliente,
  }) async {
    // ignore: type_check_with_null
    if (empleado is Null) {
      client = MdlClient.fromJson(cliente!.docs.first.data());
      await SesionHelper.guardarCliente(client!);
    } else {
      employ = MdlEmploy.fromJson(empleado.docs.first.data());
      await SesionHelper.guardarEmpleado(employ!);
    }
  }
}
