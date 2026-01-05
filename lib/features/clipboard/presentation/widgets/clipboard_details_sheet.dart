import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/clipboard_item.dart';

class ClipboardDetailsSheet extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onDelete;
  final VoidCallback onPinToggle;
  final VoidCallback onCopy;
  final ScrollController? scrollController;

  const ClipboardDetailsSheet({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPinToggle,
    required this.onCopy,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.outlineVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    timeago.format(item.createdAt.toLocal()),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onCopy,
                  icon: Icon(
                    Icons.copy_all_outlined,
                    color: context.colorScheme.primary,
                  ),
                  tooltip: 'Copy',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.error,
                  ),
                  tooltip: 'Delete',
                ),
                IconButton(
                  onPressed: onPinToggle,
                  icon: Icon(
                    item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: item.isPinned ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: item.isPinned ? 'Unpin' : 'Pin',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SelectableText(
                item.content,
                style: context.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
