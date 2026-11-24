import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.api});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Login')));
  }
}
