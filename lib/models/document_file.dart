class DocumentFile {
  const DocumentFile({required this.id, required this.fileName});

  final int id;
  final String fileName;

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      id: json['id'] as int,
      fileName: json['file_name'] as String,
    );
  }
}
