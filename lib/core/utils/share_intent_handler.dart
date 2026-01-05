import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:injectable/injectable.dart';
import '../../features/clipboard/presentation/bloc/clipboard_bloc.dart';
import '../../features/clipboard/presentation/bloc/clipboard_event.dart';

@singleton
class ShareIntentHandler {
  StreamSubscription? _intentDataStreamSubscription;

  void initialize(BuildContext context) {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        final text = value.first.path; // For text, path contains the content
        if (text.isNotEmpty) {
          _addClip(context, text);
        }
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        final text = value.first.path;
        if (text.isNotEmpty) {
          _addClip(context, text);
          // Clear the intent so it doesn't re-trigger on reload
          ReceiveSharingIntent.instance.reset();
        }
      }
    });
  }

  void _addClip(BuildContext context, String text) {
    context.read<ClipboardBloc>().add(AddClipboardItem(text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved from Share')),
    );
  }

  void dispose() {
    _intentDataStreamSubscription?.cancel();
  }
}
