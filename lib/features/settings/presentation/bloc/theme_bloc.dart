import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeBloc(this._prefs) : super(const ThemeState()) {
    on<SetThemeMode>(_onSetThemeMode);
    _loadSavedTheme();
  }

  void _onSetThemeMode(SetThemeMode event, Emitter<ThemeState> emit) async {
    await _prefs.setString(_themeKey, event.mode.toString());
    emit(ThemeState(themeMode: event.mode));
  }

  void _loadSavedTheme() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      add(SetThemeMode(mode));
    }
  }
}
