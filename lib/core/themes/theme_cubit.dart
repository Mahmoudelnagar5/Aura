import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'light_theme.dart';
import 'dark_theme.dart';
import 'package:aura/core/helpers/database/cache_helper.dart';
import 'package:aura/core/di/service_locator.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String _themeKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.system;
  final cacheHelper = getIt<CacheHelper>();

  ThemeCubit() : super(lightTheme) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final value = cacheHelper.getData(key: _themeKey);
    if (value == 'dark') {
      _themeMode = ThemeMode.dark;
      emit(darkTheme);
    } else if (value == 'light') {
      _themeMode = ThemeMode.light;
      emit(lightTheme);
    } else {
      _themeMode = ThemeMode.system;
      emit(lightTheme); // Default to lightTheme for initial state
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    emit(mode == ThemeMode.dark ? darkTheme : lightTheme);
    await cacheHelper.saveData(
      key: _themeKey,
      value: mode == ThemeMode.system
          ? 'system'
          : mode == ThemeMode.dark
              ? 'dark'
              : 'light',
    );
  }
}
