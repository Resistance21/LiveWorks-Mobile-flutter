import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 10.0.2.2 is how the Android emulator reaches your PC's localhost.
const String apiBase = 'http://10.0.2.2:8000/api';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveWorks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HelloScreen(),
    );
  }
}

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  late Future<String> _message;

  @override
  void initState() {
    super.initState();
    _message = _fetchHello();
  }

  Future<String> _fetchHello() async {
    final response = await http
        .get(
          Uri.parse('$apiBase/ping'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server returned ${response.statusCode}');
    }
    return jsonDecode(response.body)['message'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LiveWorks')),
      body: Center(
        child: FutureBuilder<String>(
          future: _message,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not reach the API:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _message = _fetchHello()),
                    child: const Text('Retry'),
                  ),
                ],
              );
            }
            return Text(
              snapshot.data!,
              style: Theme.of(context).textTheme.headlineSmall,
            );
          },
        ),
      ),
    );
  }
}
