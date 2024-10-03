import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/services/settings_service.dart';

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return _strToThemeMode(
        ref.watch(settingsServiceProvider).getSetting(SettingsEnum.themeMode));
  }

  void changeThemeMode(ThemeMode themeMode) {
    ref
        .read(settingsServiceProvider)
        .setSetting(SettingsEnum.themeMode, _themeModeToStr(themeMode));
    state = themeMode;
  }

  String _themeModeToStr(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _strToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

extension ThemeModeExtension on ThemeMode {
  String get label =>
      {
        'light': '白天',
        'dark': '夜间',
        'system': '系统',
      }[name] ??
      '';
}
