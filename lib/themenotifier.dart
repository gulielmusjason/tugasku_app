import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _key = 'theme_mode';

  ThemeNotifier(super.mode) {
    _loadSavedThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    value = mode;
    _saveThemeMode(mode);
  }

  Future<void> _loadSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_key);
    if (savedMode != null) {
      value = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString());
  }
}

class ThemeNotifierProvider extends InheritedNotifier<ThemeNotifier> {
  const ThemeNotifierProvider({
    super.key,
    required ThemeNotifier super.notifier,
    required super.child,
  });

  static ThemeNotifier? of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeNotifierProvider>();
    return provider?.notifier;
  }

  static ThemeNotifier maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeNotifierProvider>();
    return provider?.notifier ?? ThemeNotifier(ThemeMode.system);
  }
}
