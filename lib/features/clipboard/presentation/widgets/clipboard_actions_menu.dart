import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';

class ClipboardActionsMenu extends StatelessWidget {
  final VoidCallback onClearAll;

  const ClipboardActionsMenu({
    super.key,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'clear_all') {
          onClearAll();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'clear_all',
            child: Row(
              children: [
                Icon(
                  Icons.delete_sweep_outlined,
                  color: context.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Delete All Clips',
                  style: TextStyle(color: context.colorScheme.error),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
