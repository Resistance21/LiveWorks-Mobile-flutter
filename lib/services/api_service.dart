import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liveworks_mobile_flutter/models/project.dart';
import 'package:file_picker/file_picker.dart';
import 'package:liveworks_mobile_flutter/models/unit.dart';
import 'package:liveworks_mobile_flutter/models/assessment.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  String? token;

  Map<String, String> get _authHeaders => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<String> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/login');

    final response = await http
        .post(
          uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      token = data['token'] as String;
      await _saveToken(token!);
      return data['role'] as String;
    }

    if (response.statusCode == 422) {
      throw Exception('Invalid email or password');
    }

    throw Exception('Server error (${response.statusCode})');
  }

  Future<void> _saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', value);
  }

  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('token');
    if (saved == null) return false;

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/user'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $saved',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        token = saved;
        return true;
      }
    } catch (_) {
      // Network problem: treat as not logged in.
    }

    await prefs.remove('token');
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
  }

  Future<List<Project>> fetchProjects() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/projects'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((item) => Project.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Session expired, please log in again');
    }

    throw Exception('Server error (${response.statusCode})');
  }

  Future<List<Unit>> fetchUnits() async {
    final response = await http
        .get(Uri.parse('$baseUrl/units'), headers: _authHeaders)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Unit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Assessment>> fetchAssessments(int unitId) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/units/$unitId/assessments'),
          headers: _authHeaders,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Assessment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> uploadProject({
    required int assessmentId,
    required String description,
    required PlatformFile zip,
    required List<PlatformFile> documents,
  }) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/projects'))
          ..headers.addAll(_authHeaders)
          ..fields['assessment_id'] = assessmentId.toString();

    if (description.isNotEmpty) {
      request.fields['project_description'] = description;
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'project',
        await zip.readAsBytes(),
        filename: zip.name,
      ),
    );
    for (final doc in documents) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'documentation[]',
          await doc.readAsBytes(),
          filename: doc.name,
        ),
      );
    }

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) return;

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Upload rejected');
    }

    throw Exception('Server error (${response.statusCode})');
  }
}
