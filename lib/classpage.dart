import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _tasks = [
    {'title': 'Tugas Matematika', 'dueDate': '2023-06-15'},
    {'title': 'Proyek IPA', 'dueDate': '2023-06-20'},
    {'title': 'Esai Bahasa Indonesia', 'dueDate': '2023-06-18'},
  ];

  final List<Map<String, String>> _members = [
    {'name': 'Budi Santoso', 'role': 'Siswa'},
    {'name': 'Ani Wijaya', 'role': 'Siswa'},
    {'name': 'Citra Purnama', 'role': 'Siswa'},
    {'name': 'Dedi Kurniawan', 'role': 'Siswa'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tugas'),
            Tab(text: 'Anggota Pelajar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(task['title']!),
                    subtitle: Text('Batas waktu: ${task['dueDate']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  );
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(member['name']![0]),
                    ),
                    title: Text(member['name']!),
                    subtitle: Text(member['role']!),
                    onTap: () {},
                  );
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
