import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/di/injection.dart';

Future<void> mainCommon(String envFile) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: envFile);
  await configureDependencies();
  
  Bloc.observer = AppBlocObserver();
  
  runApp(const ClipboardManagerApp());
}

void main() async {
  // Default to development if run directly
  await mainCommon('.env.development');
}

