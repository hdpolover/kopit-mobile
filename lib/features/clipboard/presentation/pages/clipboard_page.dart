import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/share_intent_handler.dart';
import '../../../../core/utils/clipboard_watcher_service.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';
import '../bloc/clipboard_state.dart';
import '../widgets/clipboard_drawer.dart';
import '../widgets/clipboard_empty_view.dart';
import '../widgets/clipboard_list.dart';
import '../widgets/clipboard_search_bar.dart';

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
  @override
  void initState() {
    super.initState();
    // Initialize Share Intent Handler
    getIt<ShareIntentHandler>().initialize(context);
    // Initialize Clipboard Watcher
    getIt<ClipboardWatcherService>().initialize(context);
  }

  @override
  void dispose() {
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
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar.large(
                  title: Text(
                    EnvConfig.appName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  centerTitle: false,
                ),
              const SliverToBoxAdapter(
                child: ClipboardSearchBar(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Debug: Add dummy item
          context.read<ClipboardBloc>().add(AddClipboardItem('Test Clip ${DateTime.now()}'));
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
    );
  }
}
