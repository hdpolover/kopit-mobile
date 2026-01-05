import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_card.dart';
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
    return AppCard(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ListTile(
        title: Text(
          item.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge,
        ),
        subtitle: Text(
          item.createdAt.toLocal().formattedDateTime,
          style: context.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(
            item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: item.isPinned ? context.colorScheme.primary : null,
          ),
          onPressed: onPinToggle,
        ),
      ),
    );
  }
}
