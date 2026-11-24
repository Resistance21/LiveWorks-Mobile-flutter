import 'dart:convert';

import 'package:http/http.dart' as http;

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
}
