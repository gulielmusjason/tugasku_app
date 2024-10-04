import 'package:flutter/material.dart';
import 'package:tugasku_app/activitypagemenu.dart';
import 'package:tugasku_app/classpagemenu.dart';
import 'package:tugasku_app/settingpage.dart';
import 'package:tugasku_app/signinpage.dart';
import 'package:tugasku_app/taskpage.dart';

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

  static final List<Widget> _widgetOptions = <Widget>[
    const ClassPageMenu(),
    const TaskPage(),
    const ActivityPage(),
  ];

  static final List<String> _appBarTitles = [
    'Kelas',
    'Tugas',
    'Aktivitas',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(_appBarTitles[_selectIndex]),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon:
                    Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: SizedBox(
          width: 250,
          child: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(0),
              ),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Keluar'),
                  onTap: () {
                    Navigator.pop(context); // Tutup drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Kelas"),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tugas"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Aktivitas")
          ],
          currentIndex: _selectIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
