import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'evaluation.dart';
import 'mission.dart';

class ClassPage extends StatefulWidget {
  final String className;
  const ClassPage({super.key, required this.className});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _tasks = [];

  final List<Map<String, String>> _members = [
    {'name': 'Ani Wijaya', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
    {'name': 'Indah Permata', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
    {'name': 'Fajar Ramadhan', 'role': 'Siswa', 'class': 'Bahasa Inggris'},
    {'name': 'Kartika Sari', 'role': 'Siswa', 'class': 'Bahasa Inggris'},
    {'name': 'Citra Purnama', 'role': 'Siswa', 'class': 'IPA'},
    {'name': 'Hadi Prasetyo', 'role': 'Siswa', 'class': 'IPA'},
    {'name': 'Eka Putri', 'role': 'Siswa', 'class': 'IPS'},
    {'name': 'Joko Widodo', 'role': 'Siswa', 'class': 'IPS'},
    {'name': 'Budi Santoso', 'role': 'Siswa', 'class': 'Matematika'},
    {'name': 'Dedi Kurniawan', 'role': 'Siswa', 'class': 'Matematika'},
    {'name': 'Gita Nirmala', 'role': 'Siswa', 'class': 'Matematika'},
    {'name': 'Luhut Pandjaitan', 'role': 'Siswa', 'class': 'Matematika'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi untuk memuat tugas dari penyimpanan lokal
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks') ?? '[]';
    final tasksList = json.decode(tasksJson) as List;
    setState(() {
      _tasks = tasksList.map((task) {
        return {
          'name': task['name'],
          'class': task['class'],
          'dueDate': DateTime.parse(task['dueDate']),
        };
      }).toList();
    });
  }

  // Fungsi untuk menyimpan tugas ke penyimpanan lokal
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(_tasks.map((task) {
      return {
        'name': task['name'],
        'class': task['class'],
        'dueDate': task['dueDate'].toIso8601String(),
      };
    }).toList());
    await prefs.setString('tasks', tasksJson);
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
      ..sort((a, b) => a['dueDate'].compareTo(b['dueDate']));

    return Stack(
      children: [
        ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11)),
              child: ListTile(
                title: Text(task['name']),
                subtitle:
                    Text('Jatuh tempo: ${_formatDateTime(task['dueDate'])}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => _navigateToTaskEvaluation(task['name']),
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

  void _addNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(className: widget.className),
      ),
    );

    if (result != null) {
      setState(() {
        _tasks.add(result);
      });
      await _saveTasks(); // Simpan tugas setelah menambahkan
    }
  }

  void _navigateToTaskEvaluation(String taskName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationPage(
          className: widget.className,
          itemName: taskName,
          isTask: true,
        ),
      ),
    );

    if (result != null) {
      // Implementasi logika untuk menyimpan hasil evaluasi tugas
      print('Nilai tugas: ${result['score']}, Feedback: ${result['feedback']}');
      // Anda bisa menambahkan logika untuk memperbarui data tugas di sini
    }
  }

  void _navigateToEvaluation(String studentName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationPage(
          className: widget.className,
          itemName: studentName,
          isTask: false,
        ),
      ),
    );

    if (result != null) {
      // Implementasi logika untuk menyimpan hasil evaluasi siswa
      print('Nilai siswa: ${result['score']}, Feedback: ${result['feedback']}');
      // Anda bisa menambahkan logika untuk memperbarui data siswa di sini
    }
  }

  Widget _buildMemberList() {
    final filteredMembers = _members
        .where((member) => member['class'] == widget.className)
        .toList();

    return Stack(
      children: [
        ListView.builder(
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
    );
  }

  String _formatDateTime(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    const dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year} ${dayNames[date.weekday - 1]} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}