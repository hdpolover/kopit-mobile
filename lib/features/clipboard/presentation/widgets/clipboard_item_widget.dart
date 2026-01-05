import 'package:flutter/material.dart';
import '../../domain/entities/clipboard_item.dart';

class ClipboardItemWidget extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onPinToggle;

  const ClipboardItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onLongPress,
    required this.onPinToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          item.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          item.createdAt.toLocal().toString().split('.')[0],
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: item.isPinned ? Theme.of(context).primaryColor : null,
          ),
          onPressed: onPinToggle,
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
