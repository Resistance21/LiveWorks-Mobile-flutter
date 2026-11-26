import 'package:liveworks_mobile_flutter/models/archive_file.dart';
import 'package:liveworks_mobile_flutter/models/document_file.dart';

class ProjectDetail {
  const ProjectDetail({
    required this.id,
    required this.name,
    required this.status,
    required this.unitCode,
    required this.unitName,
    required this.assessmentName,
    required this.year,
    required this.documents,
    this.description,
    this.uploadedBy,
    this.archive,
  });

  final int id;
  final String name;
  final String status;
  final String? description;
  final String unitCode;
  final String unitName;
  final String assessmentName;
  final String year;
  final String? uploadedBy;
  final ArchiveFile? archive;
  final List<DocumentFile> documents;

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    final unit = json['unit'] as Map<String, dynamic>;
    final assessment = json['assessment'] as Map<String, dynamic>;
    final archive = json['archive'] as Map<String, dynamic>?;
    final members = json['members'] as List<dynamic>;

    return ProjectDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      unitCode: unit['code'] as String,
      unitName: unit['name'] as String,
      assessmentName: assessment['name'] as String,
      year: assessment['year'].toString(),
      uploadedBy: members.isEmpty
          ? null
          : (members.first as Map<String, dynamic>)['name'] as String,
      archive: archive == null ? null : ArchiveFile.fromJson(archive),
      documents: (json['documents'] as List<dynamic>)
          .map((d) => DocumentFile.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
