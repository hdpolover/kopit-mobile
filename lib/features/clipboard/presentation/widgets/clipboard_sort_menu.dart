import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';

class ClipboardSortMenu extends StatelessWidget {
  const ClipboardSortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Sort & Filter',
      onSelected: (value) {
        if (value == 'sort_newest') {
          context.read<ClipboardBloc>().add(const SortClipboardItems(SortOrder.newest));
        } else if (value == 'sort_oldest') {
          context.read<ClipboardBloc>().add(const SortClipboardItems(SortOrder.oldest));
        } else if (value == 'sort_alphabetical') {
          context.read<ClipboardBloc>().add(const SortClipboardItems(SortOrder.alphabetical));
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'sort_newest',
            child: Row(
              children: [
                Icon(Icons.schedule),
                SizedBox(width: 12),
                Text('Newest First'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'sort_oldest',
            child: Row(
              children: [
                Icon(Icons.history),
                SizedBox(width: 12),
                Text('Oldest First'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'sort_alphabetical',
            child: Row(
              children: [
                Icon(Icons.sort_by_alpha),
                SizedBox(width: 12),
                Text('Alphabetical'),
              ],
            ),
          ),
        ];
      },
    );
  }
}
