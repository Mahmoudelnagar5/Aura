import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aura/core/helpers/database/cache_helper.dart';
import 'package:aura/core/di/service_locator.dart';
import 'theme_state.dart';

enum ThemeModeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'themeMode';
  final cacheHelper = getIt<CacheHelper>();

  ThemeCubit() : super(ThemeInitialState()) {
    _loadTheme();
  }
  static ThemeCubit get(context) => BlocProvider.of(context);

  ThemeModeState currentTheme = ThemeModeState.system;

  Future<void> _loadTheme() async {
    final value = cacheHelper.getData(key: _themeKey);

    if (value != null) {
      currentTheme = ThemeModeState.values.firstWhere(
        (element) => element.name == value,
        orElse: () => ThemeModeState.system,
      );
    }
    emit(ThemeChangedState());
  }

  ThemeMode getTheme() {
    switch (currentTheme) {
      case ThemeModeState.light:
        return ThemeMode.light;
      case ThemeModeState.dark:
        return ThemeMode.dark;
      case ThemeModeState.system:
        return ThemeMode.system;
    }
  }

  Future<void> selectTheme(ThemeModeState theme) async {
    currentTheme = theme;
    await cacheHelper.saveData(
      key: _themeKey,
      value: currentTheme.name,
    );
    emit(ThemeChangedState());
  }
}
