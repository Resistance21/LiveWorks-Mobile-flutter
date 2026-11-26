import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/widgets/app_header.dart';

class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({super.key, required this.api});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(title: 'Upload project'),
      body: Center(child: Text('Upload form goes here')),
    );
  }
}
