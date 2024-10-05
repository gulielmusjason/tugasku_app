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

  void _tambahKelas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Kelas'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Masukkan kode kelas'),
            onSubmitted: (String kodeKelas) {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: _classes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11)),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClassPage(className: _classes[index]['name'])),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKelas,
        child: const Icon(Icons.add),
      ),
    );
  }
}
