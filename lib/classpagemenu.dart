import 'package:flutter/material.dart';
import 'package:tugasku_app/classpage.dart';

class ClassPageMenu extends StatefulWidget {
  const ClassPageMenu({super.key});

  @override
  State<ClassPageMenu> createState() => _ClassPageMenuState();
}

class _ClassPageMenuState extends State<ClassPageMenu> {
  final List<Map<String, dynamic>> _classes = [
    {'name': 'Matematika', 'teacher': 'Pak Budi', 'icon': Icons.calculate},
    {'name': 'Bahasa Indonesia', 'teacher': 'Ibu Siti', 'icon': Icons.book},
    {'name': 'IPA', 'teacher': 'Pak Andi', 'icon': Icons.science},
    {'name': 'IPS', 'teacher': 'Ibu Rina', 'icon': Icons.public},
    {'name': 'Bahasa Inggris', 'teacher': 'Mr. John', 'icon': Icons.language},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _classes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(_classes[index]['icon'],
                  color: Theme.of(context).primaryColor, size: 30),
              title: Text(_classes[index]['name']),
              subtitle: Text(_classes[index]['teacher']),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClassPage(),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
