import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/clipboard_watcher_service.dart';
import '../../domain/entities/clipboard_item.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';
import 'clipboard_details_sheet.dart';
import 'clipboard_item_widget.dart';

class ClipboardList extends StatelessWidget {
  final List<ClipboardItem> items;

  const ClipboardList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
            ),
            onDismissed: (direction) {
              context.read<ClipboardBloc>().add(DeleteClipboardItem(item.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item deleted'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: ClipboardItemWidget(
              item: item,
              onTap: () => _showDetails(context, item),
              onCopy: () => _handleCopy(context, item),
              onLongPress: () => _showDetails(context, item),
              onPinToggle: () {
                context.read<ClipboardBloc>().add(TogglePinItem(item.id));
              },
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  void _handleCopy(BuildContext context, ClipboardItem item) {
    getIt<ClipboardWatcherService>().copyToClipboard(item.content);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, ClipboardItem item) {
    // Capture the Bloc from the parent context
    final clipboardBloc = context.read<ClipboardBloc>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: const [0.6, 0.9],
        builder: (context, scrollController) => ClipboardDetailsSheet(
          item: item,
          scrollController: scrollController,
          onCopy: () {
            _handleCopy(context, item);
            Navigator.pop(bottomSheetContext);
          },
          onDelete: () {
            clipboardBloc.add(DeleteClipboardItem(item.id));
            Navigator.pop(bottomSheetContext);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Item deleted'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          onPinToggle: () {
            clipboardBloc.add(TogglePinItem(item.id));
            Navigator.pop(bottomSheetContext);
          },
        ),
      ),
    );
  }
}
