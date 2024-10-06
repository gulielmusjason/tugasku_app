import 'package:flutter/material.dart';
import 'package:tugasku_app/classpagemenu.dart';
import 'package:tugasku_app/notificationpagemenu.dart';
import 'package:tugasku_app/settingpage.dart';
import 'package:tugasku_app/taskpagemenu.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

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
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  'NP',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
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
            UserAccountsDrawerHeader(
              accountName: const Text('Nama Pengguna'),
              accountEmail: const Text('pengguna@email.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  'NP',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () => _navigateTo(const SettingPage()),
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
