class ArchiveFile {
  const ArchiveFile({required this.id, required this.fileName});

  final int id;
  final String fileName;

  factory ArchiveFile.fromJson(Map<String, dynamic> json) {
    return ArchiveFile(
      id: json['id'] as int,
      fileName: json['file_name'] as String,
    );
  }
}
