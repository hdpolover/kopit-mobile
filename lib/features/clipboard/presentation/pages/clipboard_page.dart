import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/share_intent_handler.dart';
import '../../../../core/utils/clipboard_watcher_service.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';
import '../bloc/clipboard_state.dart';
import '../widgets/clipboard_actions_menu.dart';
import '../widgets/clipboard_delete_all_dialog.dart';
import '../widgets/clipboard_drawer.dart';
import '../widgets/clipboard_empty_view.dart';
import '../widgets/clipboard_list.dart';
import '../widgets/clipboard_search_field.dart';
import '../widgets/clipboard_sort_menu.dart';

class ClipboardPage extends StatelessWidget {
  const ClipboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClipboardBloc>()..add(LoadClipboardItems()),
      child: const ClipboardView(),
    );
  }
}

class ClipboardView extends StatefulWidget {
  const ClipboardView({super.key});

  @override
  State<ClipboardView> createState() => _ClipboardViewState();
}

class _ClipboardViewState extends State<ClipboardView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    getIt<ShareIntentHandler>().initialize(context);
    getIt<ClipboardWatcherService>().initialize(context);
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        context.read<ClipboardBloc>().add(SearchClipboardItems(''));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    getIt<ShareIntentHandler>().dispose();
    getIt<ClipboardWatcherService>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ClipboardDrawer(),
      body: BlocBuilder<ClipboardBloc, ClipboardState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClipboardBloc>().add(LoadClipboardItems());
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: _isSearchExpanded
                      ? ClipboardSearchField(
                          key: const ValueKey('search_field'),
                          controller: _searchController,
                        )
                      : null,
                  actions: [
                    IconButton(
                      icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
                      onPressed: _toggleSearch,
                    ),
                    if (!_isSearchExpanded) const ClipboardSortMenu(),
                    if (!_isSearchExpanded)
                      ClipboardActionsMenu(
                        onClearAll: () => ClipboardDeleteAllDialog.show(context),
                      ),
                  ],
                ),
                if (state is ClipboardLoading)
                  const SliverFillRemaining(
                    child: Center(child: AppLoader()),
                  )
                else if (state is ClipboardLoaded)
                  if (state.items.isEmpty)
                    const SliverFillRemaining(
                      child: ClipboardEmptyView(),
                    )
                  else
                    ClipboardList(items: state.items)
                else if (state is ClipboardError)
                  SliverFillRemaining(
                    child: Center(
                      child: AppErrorView(
                        message: state.message,
                        onRetry: () {
                          context.read<ClipboardBloc>().add(LoadClipboardItems());
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
