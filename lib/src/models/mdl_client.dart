class MdlClient {
  final String dni;
  final String name;
  final String lname;
  final String address;
  final String phone;

  MdlClient({
    required this.dni,
    required this.name,
    required this.lname,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'DNI': dni,
      'Name': name,
      'LName': lname,
      'Address': address,
      'Phone': phone,
    };
  }

  factory MdlClient.fromJson(Map<String, dynamic> json) {
    return MdlClient(
      dni: json['DNI'],
      name: json['Name'],
      lname: json['LName'],
      address: json['Address'],
      phone: json['Phone'],
    );
  }
}
