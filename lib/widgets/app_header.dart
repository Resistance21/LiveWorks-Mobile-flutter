import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';
import 'package:liveworks_mobile_flutter/widgets/tafe_logo.dart';
import 'package:liveworks_mobile_flutter/widgets/theme_toggle_button.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final statusBar = view.padding.top / view.devicePixelRatio;
    return Size.fromHeight(statusBar + 56 + 48);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: const Row(children: [TafeLogo(height: 32), Spacer()]),
              ),
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
            ),
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const ThemeToggleButton(),
                ...?actions,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
