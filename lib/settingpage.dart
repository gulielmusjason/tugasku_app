import 'package:flutter/material.dart';
import 'package:tugasku_app/themenotifier.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ThemeNotifierProvider.maybeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Tema'),
            trailing: _buildThemeDropdown(themeNotifier),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDropdown(ThemeNotifier? themeNotifier) {
    return DropdownButton<ThemeMode>(
      value: themeNotifier?.value,
      onChanged: (ThemeMode? newThemeMode) {
        if (newThemeMode != null) {
          themeNotifier?.setThemeMode(newThemeMode);
        }
      },
      items: const [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('Sistem'),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Terang'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Gelap'),
        ),
      ],
    );
  }
}