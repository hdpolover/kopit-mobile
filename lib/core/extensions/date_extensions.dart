import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String get formattedDate => DateFormat('MMM d, yyyy').format(this);
  String get formattedTime => DateFormat('h:mm a').format(this);
  String get formattedDateTime => '$formattedDate $formattedTime';
}
