import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get flavor => dotenv.env['FLAVOR'] ?? 'unknown';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Kopit';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
