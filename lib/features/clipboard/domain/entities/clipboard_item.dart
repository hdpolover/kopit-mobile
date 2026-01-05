import 'package:equatable/equatable.dart';

class ClipboardItem extends Equatable {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool isPinned;
  final String? category;

  const ClipboardItem({
    required this.id,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.category,
  });

  @override
  List<Object?> get props => [id, content, createdAt, isPinned, category];
}
