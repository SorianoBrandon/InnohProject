class MdlEmploy {
  final String dni;
  final String name;
  final String password;
  final String phone;
  final String role;
  final String user;
  final int flag;

  MdlEmploy({
    required this.dni,
    required this.name,
    required this.password,
    required this.phone,
    required this.role,
    required this.user,
    this.flag = 1, // valor por defecto si no se define
  });

  Map<String, dynamic> toJson() {
    return {
      'DNI': dni,
      'Name': name,
      'Password': password,
      'Phone': phone,
      'Role': role,
      'User': user,
      'flag': flag,
    };
  }

  factory MdlEmploy.fromJson(Map<String, dynamic> json) {
    return MdlEmploy(
      dni: json['DNI'] ?? '',
      name: json['Name'] ?? '',
      password: json['Password'] ?? '',
      phone: json['Phone'] ?? '',
      role: json['Role'] ?? '',
      user: json['User'] ?? '',
      flag: json['flag'] ?? 1, // usa 1 si no está definido
    );
  }
}
