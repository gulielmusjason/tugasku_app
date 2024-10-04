import 'package:flutter/material.dart';

import 'classpage.dart';
import 'mission.dart';

class ClassPageMenu extends StatefulWidget {
  const ClassPageMenu({super.key});

  @override
  _ClassPageMenuState createState() => _ClassPageMenuState();
}

class _ClassPageMenuState extends State<ClassPageMenu> {
  final List<Map<String, dynamic>> _classes = [
    {'name': 'Matematika', 'teacher': 'Pak Budi', 'icon': Icons.calculate},
    {'name': 'Bahasa Indonesia', 'teacher': 'Ibu Siti', 'icon': Icons.book},
    {'name': 'IPA', 'teacher': 'Pak Andi', 'icon': Icons.science},
    {'name': 'IPS', 'teacher': 'Ibu Rina', 'icon': Icons.public},
    {'name': 'Bahasa Inggris', 'teacher': 'Mr. John', 'icon': Icons.language},
  ];

  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionPage(
          classes: _classes.map((c) => c['name'] as String).toList(),
          onNewTask: (newTask) {
            // Implementasi penambahan tugas baru
            // Anda mungkin perlu meneruskan ini ke ClassPage yang sesuai
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _classes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassPage(className: _classes[index]['name']),
                ),
              ),
              child: ListTile(
                leading: Icon(_classes[index]['icon'],
                    color: Theme.of(context).primaryColor, size: 30),
                title: Text(_classes[index]['name']),
                subtitle: Text(_classes[index]['teacher']),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
