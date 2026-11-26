import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    mode.value = prefs.getString('theme_mode') == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> toggle() async {
    mode.value = mode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      mode.value == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
