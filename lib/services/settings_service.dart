import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

enum SettingsEnum<T> {
  themeMode('themeMode', 'light');

  final String key;
  final T defaultValue;
  const SettingsEnum(this.key, this.defaultValue);
}

class SettingsService {
  final box = Hive.box('settings');

  T getSetting<T>(SettingsEnum<T> setting) {
    return box.get(setting.key, defaultValue: setting.defaultValue);
  }

  Future<void> setSetting<T>(SettingsEnum<T> setting, T value) {
    return box.put(setting.key, value);
  }

  Future<void> removeSetting<T>(SettingsEnum<T> setting) {
    return box.delete(setting.key);
  }

  Future<int> clearSetting() async {
    return box.clear();
  }
}

final settingsServiceProvider = StateProvider<SettingsService>((ref) {
  return SettingsService();
});
