import 'package:flutter/material.dart';
import 'package:tugasku_app/signinpage.dart';
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
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            trailing: _buildThemeDropdown(themeNotifier),
          ),
          ListTile(
            title: const Text('Keluar'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
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
