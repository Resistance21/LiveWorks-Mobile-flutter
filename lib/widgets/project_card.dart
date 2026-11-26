import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/models/project.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.onTap});

  static const int _descriptionLimit = 150;

  final Project project;
  final VoidCallback? onTap;

  String? get _shortDescription {
    final text = project.description?.trim();
    if (text == null || text.isEmpty) return null;
    if (text.length <= _descriptionLimit) return text;
    return '${text.substring(0, _descriptionLimit)}...';
  }

  @override
  Widget build(BuildContext context) {
    final d = project.createdAt.toLocal();
    final version = project.latestArchiveVersion;
    final description = _shortDescription;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${project.unitCode} · ${project.year} · '
                      'uploaded ${d.day}/${d.month}/${d.year}',
                      style: const TextStyle(color: AppColors.hint),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
