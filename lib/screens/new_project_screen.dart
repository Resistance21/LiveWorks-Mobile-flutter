import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/models/unit.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/widgets/app_header.dart';
import 'package:liveworks_mobile_flutter/models/unit.dart';
import 'package:liveworks_mobile_flutter/models/assessment.dart';
import 'package:liveworks_mobile_flutter/widgets/loading_button.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  static const int _maxBytes = 10 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  late final Future<List<Unit>> _units;
  Future<List<Assessment>>? _assessments;
  int? _unitId;
  Assessment? _assessment;

  PlatformFile? _zip;
  final List<PlatformFile> _documents = [];

  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _units = widget.api.fetchUnits();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onUnitChanged(Unit? unit) {
    if (unit == null) return;
    setState(() {
      _unitId = unit.id;
      _assessment = null;
      _assessments = widget.api.fetchAssessments(unit.id);
    });
  }

  Future<void> _pickZip() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (file == null || !mounted) return;
    setState(() {
      _zip = file;
      _error = null;
    });
  }

  Future<void> _pickDocuments() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );
    if (files.isEmpty || !mounted) return;
    setState(() => _documents.addAll(files));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final zip = _zip;
    if (zip == null) {
      setState(() => _error = 'Choose the project zip file');
      return;
    }

    setState(() {
      _uploading = true;
      _error = null;
    });

    try {
      final size = await zip.length();
      if (size != null && size > _maxBytes) {
        throw Exception('The zip must be 10 MB or smaller');
      }

      await widget.api.uploadProject(
        assessmentId: _assessment!.id,
        description: _descriptionController.text.trim(),
        zip: zip,
        documents: _documents,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Project uploaded')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _uploading = false;
      });
    }
  }

  Widget _unitField() {
    return FutureBuilder<List<Unit>>(
      future: _units,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Could not load units');
        }
        final units = snapshot.data ?? const <Unit>[];
        return DropdownButtonFormField<Unit>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Unit',
            helperText: snapshot.hasData ? null : 'Loading...',
          ),
          items: [
            for (final u in units)
              DropdownMenuItem(
                value: u,
                child: Text(
                  '${u.unitCode} - ${u.unitName}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: _uploading ? null : _onUnitChanged,
          validator: (value) => value == null ? 'Choose a unit' : null,
        );
      },
    );
  }

  Widget _assessmentField() {
    final future = _assessments;
    if (future == null) {
      return DropdownButtonFormField<Assessment>(
        decoration: const InputDecoration(
          labelText: 'Assessment',
          helperText: 'Choose a unit first',
        ),
        items: const [],
        onChanged: null,
      );
    }

    return FutureBuilder<List<Assessment>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Could not load assessments');
        }
        final list = snapshot.data ?? const <Assessment>[];
        return DropdownButtonFormField<Assessment>(
          key: ValueKey('assessment-$_unitId'),
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Assessment',
            helperText: snapshot.hasData ? null : 'Loading...',
          ),
          items: [
            for (final a in list)
              DropdownMenuItem(
                value: a,
                child: Text(
                  '${a.name} (${a.year})',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: _uploading
              ? null
              : (value) => setState(() => _assessment = value),
          validator: (value) => value == null ? 'Choose an assessment' : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Upload project'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _unitField(),
                    const SizedBox(height: 16),
                    _assessmentField(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLength: 256,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _uploading ? null : _pickZip,
                      icon: const Icon(Icons.folder_zip),
                      label: Text(_zip?.name ?? 'Choose project zip'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _uploading ? null : _pickDocuments,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Add documents (PDF or TXT)'),
                    ),
                    if (_documents.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final doc in _documents)
                            Chip(
                              label: Text(doc.name),
                              onDeleted: _uploading
                                  ? null
                                  : () =>
                                        setState(() => _documents.remove(doc)),
                            ),
                        ],
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    LoadingButton(
                      label: 'Upload project',
                      loading: _uploading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
