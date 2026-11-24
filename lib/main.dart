import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liveworks_mobile_flutter/screens/auth_guard.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';

void main() => runApp(MyApp(api: ApiService()));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.api});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveWorks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthGate(api: api),
    );
  }
}
