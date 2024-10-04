import 'package:flutter/material.dart';

import 'mission.dart';
import 'pengumpulantugas.dart';

class ClassPage extends StatefulWidget {
  final String className;
  const ClassPage({Key? key, required this.className}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _tasks = [
    {'name': 'Tugas 1', 'class': 'Matematika', 'dueDate': DateTime.now().add(Duration(days: 7))},
    {'name': 'Tugas 2', 'class': 'Bahasa Indonesia', 'dueDate': DateTime.now().add(Duration(days: 5))},
  ];

  final List<Map<String, String>> _members = [
    {'name': 'Andi', 'role': 'Siswa', 'class': 'Matematika'},
    {'name': 'Budi', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
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

  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionPage(
          className: widget.className,
          onNewTask: (newTask) {
            setState(() {
              _tasks.add(newTask);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
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
          _buildTaskList(),
          _buildMemberList(),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final filteredTasks = _tasks
        .where((task) => task['class'] == widget.className)
        .toList()
      ..sort((a, b) => (a['dueDate'] as DateTime).compareTo(b['dueDate'] as DateTime));

    return Stack(
      children: [
        ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              child: ListTile(
                title: Text(task['name'] as String),
                subtitle: Text('Jatuh tempo: ${_formatDateTime(task['dueDate'] as DateTime)}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => _navigateToPengumpulanTugas(task),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _addNewTask,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList() {
    final filteredMembers = _members
        .where((member) => member['class'] == widget.className)
        .toList();

    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return ListTile(
          leading: CircleAvatar(child: Text(member['name']![0])),
          title: Text(member['name']!),
          subtitle: Text(member['role']!),
          onTap: () {},
        );
      },
    );
  }

  String _formatDateTime(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _navigateToPengumpulanTugas(Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengumpulanTugas(
          className: task['class'] as String,
          taskName: task['name'] as String,
        ),
      ),
    );

    if (result == true) {
      // Tugas telah dikumpulkan, perbarui status tugas
      setState(() {
        task['isSubmitted'] = true;
        task['submittedDate'] = DateTime.now();
      });
    }
  }
}