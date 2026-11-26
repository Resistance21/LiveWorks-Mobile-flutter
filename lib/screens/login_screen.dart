import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/widgets/app_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.api});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(title: 'Login'),
      body: Center(child: Text('Login')),
    );
  }
}
