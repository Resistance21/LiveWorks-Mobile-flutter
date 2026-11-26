class Project {
  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.unitCode,
    required this.year,
    required this.createdAt,
    this.description,
    this.latestArchiveVersion,
  });

  final int id;
  final String name;
  final String status;
  final String unitCode;
  final String year;
  final DateTime createdAt;
  final String? description;
  final int? latestArchiveVersion;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      unitCode: json['unit_code'] as String,
      year: json['year'].toString(),
      createdAt: DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
      latestArchiveVersion: json['latest_archive_version'] as int?,
    );
  }
}
