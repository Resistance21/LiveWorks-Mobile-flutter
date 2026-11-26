import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/models/project.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.onTap});

  final Project project;
  final VoidCallback? onTap;

  String? get _shortDescription {
    final text = project.description?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final d = project.createdAt.toLocal();
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
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.text),
                        ),
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
