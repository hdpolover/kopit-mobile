import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/clipboard/presentation/pages/clipboard_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ClipboardPage(),
    ),
  ],
);
