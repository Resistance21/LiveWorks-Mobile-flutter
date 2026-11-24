import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/services/api_service.dart';
import 'package:liveworks_mobile_flutter/screens/projects_screen.dart';
import 'package:liveworks_mobile_flutter/screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.api});
  final ApiService api;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _loggedIn;

  @override
  void initState() {
    super.initState();
    _loggedIn = widget.api.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true
            ? ProjectsScreen(api: widget.api)
            : LoginScreen(api: widget.api);
      },
    );
  }
}
