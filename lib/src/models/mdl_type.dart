class MdlType {
  final String type;

  MdlType({required this.type});

  Map<String, dynamic> toJson() {
    return {'Tipo': type};
  }

  factory MdlType.fromJson(Map<String, dynamic> json) {
    return MdlType(type: json['Tipo']);
  }
}
