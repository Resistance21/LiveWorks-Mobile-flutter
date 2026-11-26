import 'package:flutter/material.dart';
import 'package:liveworks_mobile_flutter/theme/app_theme.dart';

class FileDownloadTile extends StatelessWidget {
  const FileDownloadTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, overflow: TextOverflow.ellipsis),
        trailing: busy
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download),
        onTap: onTap,
      ),
    );
  }
}
