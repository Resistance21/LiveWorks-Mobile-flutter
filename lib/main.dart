import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liveworks_mobile_flutter/screens/auth_guard.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/screens/auth_guard.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';
import 'package:liveworks_mobile_flutter/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.load();
  runApp(MyApp(api: ApiService()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.api});

  final ApiService api;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      widget.api.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'LiveWorks',
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,
          home: AuthGate(api: widget.api),
        );
      },
    );
  }
}
