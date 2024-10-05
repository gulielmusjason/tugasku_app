import 'package:flutter/material.dart';
import 'package:tugasku_app/notificationpagemenu.dart';
import 'package:tugasku_app/classpagemenu.dart';
import 'package:tugasku_app/settingpage.dart';
import 'package:tugasku_app/signinpage.dart';
import 'package:tugasku_app/taskpagemenu.dart';

class MainApp extends StatefulWidget {
  final Function(ThemeMode) changeTheme;
  final ThemeMode currentThemeMode;

  const MainApp({
    super.key,
    required this.changeTheme,
    required this.currentThemeMode,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectIndex = 0;

  static const List<Widget> _widgetOptions = [
    ClassPageMenu(),
    TaskPageMenu(),
    NotificationPageMenu(),
  ];

  static const List<String> _appBarTitles = [
    'Kelas',
    'Tugas',
    'Notifikasi',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Center(
        child: _widgetOptions[_selectIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Text(_appBarTitles[_selectIndex]),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return SizedBox(
      width: 250,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(0)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () => _navigateTo(const SettingPage()),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(const SignInPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Kelas"),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tugas"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: "Notifikasi")
      ],
      currentIndex: _selectIndex,
      onTap: _onItemTapped,
    );
  }
}
