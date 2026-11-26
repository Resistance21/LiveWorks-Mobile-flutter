class Assessment {
  const Assessment({required this.id, required this.name, required this.year});

  final int id;
  final String name;
  final String year;

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as int,
      name: json['name'] as String,
      year: json['year'].toString(),
    );
  }
}
