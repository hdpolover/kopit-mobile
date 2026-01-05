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
      elevation: 0, // Flat style for cleaner look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority 1: The Content
              Text(
                item.content,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              
              // Priority 2: Metadata & Actions
              Row(
                children: [
                  // Time
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(item.createdAt.toLocal()),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  
                  // Copy Action
                  IconButton(
                    icon: Icon(
                      Icons.copy_all_outlined,
                      size: 20,
                      color: context.colorScheme.primary,
                    ),
                    onPressed: onCopy,
                    tooltip: 'Copy',
                    visualDensity: VisualDensity.compact,
                  ),

                  // Pin Action
                  IconButton(
                    icon: Icon(
                      item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 20,
                      color: item.isPinned ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onPinToggle,
                    tooltip: item.isPinned ? 'Unpin' : 'Pin',
                    visualDensity: VisualDensity.compact,
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
