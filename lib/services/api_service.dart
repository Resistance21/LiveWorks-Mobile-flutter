import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  String? token;

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
}
