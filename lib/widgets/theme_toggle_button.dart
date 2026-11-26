import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/theme/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          tooltip: isDark ? 'Light mode' : 'Dark mode',
          onPressed: ThemeController.toggle,
        );
      },
    );
  }
}
