class Unit {
  const Unit({
    required this.id,
    required this.unitCode,
    required this.unitName,
  });

  final int id;
  final String unitCode;
  final String unitName;

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as int,
      unitCode: json['unit_code'] as String,
      unitName: json['unit_name'] as String,
    );
  }
}
