import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';

class ClipboardSearchBar extends StatelessWidget {
  const ClipboardSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SearchBar(
        hintText: 'Search clips...',
        leading: const Icon(Icons.search),
        onChanged: (query) {
          context.read<ClipboardBloc>().add(SearchClipboardItems(query));
        },
        elevation: MaterialStateProperty.all(0),
      ),
    );
  }
}
