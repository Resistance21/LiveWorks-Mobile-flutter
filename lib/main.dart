import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liveworks_mobile_flutter/screens/auth_guard.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';

void main() => runApp(MyApp(api: ApiService()));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.api});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveWorks',
      theme: buildAppTheme(),
      home: AuthGate(api: api),
    );
  }
}
