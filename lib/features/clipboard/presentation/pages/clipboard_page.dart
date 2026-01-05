import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/share_intent_handler.dart';
import '../../../../core/utils/clipboard_watcher_service.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/clipboard_bloc.dart';
import '../bloc/clipboard_event.dart';
import '../bloc/clipboard_state.dart';
import '../widgets/clipboard_item_widget.dart';

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
    return AppScaffold(
      appBar: AppHeader(
        title: EnvConfig.appName,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search clips...',
              onChanged: (query) {
                context.read<ClipboardBloc>().add(SearchClipboardItems(query));
              },
              leading: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ClipboardBloc, ClipboardState>(
        builder: (context, state) {
          if (state is ClipboardLoading) {
            return const AppLoader();
          } else if (state is ClipboardLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No clips found'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ClipboardItemWidget(
                  item: item,
                  onTap: () {
                    getIt<ClipboardWatcherService>().copyToClipboard(item.content);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Delete Clip?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ClipboardBloc>().add(DeleteClipboardItem(item.id));
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onPinToggle: () {
                    context.read<ClipboardBloc>().add(TogglePinItem(item.id));
                  },
                );
              },
            );
          } else if (state is ClipboardError) {
            return AppErrorView(
              message: state.message,
              onRetry: () {
                context.read<ClipboardBloc>().add(LoadClipboardItems());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Debug: Add dummy item
          context.read<ClipboardBloc>().add(AddClipboardItem('Test Clip ${DateTime.now()}'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
