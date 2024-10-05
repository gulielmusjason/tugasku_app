import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(super.value);

  void setThemeMode(ThemeMode mode) {
    value = mode;
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