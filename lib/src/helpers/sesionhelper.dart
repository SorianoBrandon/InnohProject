import 'package:shared_preferences/shared_preferences.dart';
import 'package:innohproject/src/models/mdl_client.dart';
import 'package:innohproject/src/models/mdl_employ.dart';

class SesionHelper {
  static const _keyMetodo = 'metodo_sesion'; // 'cliente' o 'empleado'

  // CLIENTE
  static Future<void> guardarCliente(MdlClient cliente) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cliente_dni', cliente.dni);
    await prefs.setString('cliente_name', cliente.name);
    await prefs.setString('cliente_lname', cliente.lname);
    await prefs.setString('cliente_address', cliente.address);
    await prefs.setString('cliente_phone', cliente.phone);
    await prefs.setString(_keyMetodo, 'cliente');
  }

  static Future<MdlClient?> leerCliente() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyMetodo) != 'cliente') return null;

    return MdlClient(
      dni: prefs.getString('cliente_dni') ?? '',
      name: prefs.getString('cliente_name') ?? '',
      lname: prefs.getString('cliente_lname') ?? '',
      address: prefs.getString('cliente_address') ?? '',
      phone: prefs.getString('cliente_phone') ?? '',
    );
  }

  // EMPLEADO
  static Future<void> guardarEmpleado(MdlEmploy empleado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('empleado_dni', empleado.dni);
    await prefs.setString('empleado_password', empleado.password);
    await prefs.setString('empleado_name', empleado.name);
    await prefs.setString('empleado_rol', empleado.role);
    await prefs.setString('empleado_user', empleado.user);
    await prefs.setString('empleado_phone', empleado.phone);
    await prefs.setInt('empleado_flag', empleado.flag);
    await prefs.setString(_keyMetodo, 'empleado');
  }

  static Future<MdlEmploy?> leerEmpleado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyMetodo) != 'empleado') return null;

    return MdlEmploy(
      dni: prefs.getString('empleado_dni') ?? '',
      user: prefs.getString('empleado_user') ?? '',
      flag: prefs.getInt('empleado_flag') ?? 0,
      password: prefs.getString('empleado_password') ?? '',
      name: prefs.getString('empleado_name') ?? '',
      role: prefs.getString('empleado_rol') ?? '',
      phone: prefs.getString('empleado_phone') ?? '',
    );
  }

  // MÉTODO ACTUAL
  static Future<String?> leerMetodo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMetodo);
  }

  // BORRAR TODO
  static Future<void> borrar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
