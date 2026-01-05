import 'package:flutter/material.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/extensions/context_extensions.dart';

class ClipboardDrawer extends StatelessWidget {
  const ClipboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.content_paste_rounded,
                  size: 48,
                  color: context.colorScheme.onPrimary,
                ),
                const SizedBox(height: 16),
                Text(
                  EnvConfig.appName,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Smart clipboard manager',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {
                    // TODO: Navigate to Profile
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Preferences'),
                  onTap: () {
                    // TODO: Navigate to Settings
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.card_membership_outlined),
                  title: const Text('Subscriptions'),
                  onTap: () {
                    // TODO: Navigate to Subscriptions
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Feedback'),
                  onTap: () {
                    // TODO: Navigate to Help
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Kopit'),
            subtitle: const Text('v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Kopit',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.copy),
                children: [
                  const Text('A smart clipboard manager for your productivity.'),
                ],
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
