import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/clipboard_item.dart';

class ClipboardItemWidget extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onPinToggle;
  final VoidCallback onCopy;

  const ClipboardItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onLongPress,
    required this.onPinToggle,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Text(
                item.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              
              // Metadata & Actions
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(item.createdAt.toLocal()),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  
                  // Copy Action
                  IconButton(
                    icon: Icon(
                      Icons.copy_all_outlined,
                      size: 18,
                      color: context.colorScheme.primary,
                    ),
                    onPressed: onCopy,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Copy',
                  ),

                  // Pin Action
                  IconButton(
                    icon: Icon(
                      item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 18,
                      color: item.isPinned ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onPinToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: item.isPinned ? 'Unpin' : 'Pin',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
