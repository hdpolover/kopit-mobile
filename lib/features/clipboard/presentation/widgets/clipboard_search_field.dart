import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';

class ClipboardSearchField extends StatelessWidget {
  final TextEditingController controller;

  const ClipboardSearchField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: TextField(
          controller: controller,
          autofocus: true,
          style: context.textTheme.bodyMedium,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search clips...',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            isDense: true,
          ),
          onChanged: (query) {
            context.read<ClipboardBloc>().add(SearchClipboardItems(query));
          },
        ),
      ),
    );
  }
}
