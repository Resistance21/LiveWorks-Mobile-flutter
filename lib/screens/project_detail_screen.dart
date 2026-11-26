import 'package:liveworks_mobile_flutter/models/project_detail.dart';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/models/project.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';
import 'package:liveworks_mobile_flutter/widgets/app_header.dart';
import 'package:liveworks_mobile_flutter/widgets/file_download_tile.dart';
import 'package:liveworks_mobile_flutter/widgets/section_title.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({
    super.key,
    required this.api,
    required this.projectId,
  });

  final ApiService api;
  final int projectId;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Future<ProjectDetail> _project;
  String? _busyKey;

  @override
  void initState() {
    super.initState();
    _project = widget.api.fetchProject(widget.projectId);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _mimeFor(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.zip')) return 'application/zip';
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.txt')) return 'text/plain';
    return 'application/octet-stream';
  }

  Future<void> _save({
    required String key,
    required String fileName,
    required Future<Uint8List> Function() fetch,
  }) async {
    setState(() {
      _busyKey = key;
    });

    try {
      final bytes = await fetch();
      final saved = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: _mimeFor(fileName),
      );
      if (!mounted) return;
      if (saved != null) _toast('Saved $fileName');
    } catch (e) {
      if (!mounted) return;
      _toast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _busyKey = null;
        });
      }
    }
  }

  Widget _content(ProjectDetail p) {
    final description = p.description?.trim();
    final archive = p.archive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text('${p.unitCode} - ${p.unitName}'),
        const SizedBox(height: 4),
        Text(
          '${p.assessmentName} · ${p.year} · ${p.status}',
          style: const TextStyle(color: AppColors.hint),
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(description),
        ],
        const SectionTitle('Project archive'),
        if (archive == null)
          const Text('No archive uploaded')
        else
          FileDownloadTile(
            icon: Icons.folder_zip,
            title: archive.fileName,
            busy: _busyKey == 'archive-${archive.id}',
            onTap: _busyKey == null
                ? () => _save(
                    key: 'archive-${archive.id}',
                    fileName: archive.fileName,
                    fetch: () => widget.api.downloadArchive(archive.id),
                  )
                : null,
          ),
        const SectionTitle('Documents'),
        if (p.documents.isEmpty) const Text('No documents'),
        for (final doc in p.documents)
          FileDownloadTile(
            icon: Icons.description,
            title: doc.fileName,
            busy: _busyKey == 'document-${doc.id}',
            onTap: _busyKey == null
                ? () => _save(
                    key: 'document-${doc.id}',
                    fileName: doc.fileName,
                    fetch: () => widget.api.downloadDocument(doc.id),
                  )
                : null,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Project details'),
      body: FutureBuilder<ProjectDetail>(
        future: _project,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString().replaceFirst('Exception: ', ''),
              ),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _content(snapshot.data!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
