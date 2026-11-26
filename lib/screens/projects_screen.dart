import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/models/project.dart';
import 'package:liveworks_mobile_flutter/screens/login_screen.dart';
import 'package:liveworks_mobile_flutter/screens/new_project_screen.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/widgets/app_header.dart';
import 'package:liveworks_mobile_flutter/widgets/project_card.dart';
import 'package:flutter/foundation.dart';
import 'package:liveworks_mobile_flutter/screens/project_detail_screen.dart';
import 'package:liveworks_mobile_flutter/widgets/error_retry.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = widget.api.fetchProjects();
  }

  Future<void> _reload() async {
    debugPrint('reload started');
    final next = widget.api.fetchProjects();
    setState(() {
      _projects = next;
    });
    await next.catchError((_) => <Project>[]);
  }

  Future<void> _openUpload() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NewProjectScreen(api: widget.api)),
    );
    debugPrint('back from upload');
    if (!mounted) return;
    _reload();
  }

  Future<void> _logout() async {
    await widget.api.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen(api: widget.api)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Project archives',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: _openUpload,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload new project'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Project>>(
              future: _projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final message = snapshot.error.toString().replaceFirst(
                    'Exception: ',
                    '',
                  );
                  return ErrorRetry(message: message, onRetry: _reload);
                }

                final projects = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: projects.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No projects uploaded yet')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: projects.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return ProjectCard(
                              project: project,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProjectDetailScreen(
                                    api: widget.api,
                                    projectId: project.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
