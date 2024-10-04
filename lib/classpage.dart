import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _tasks = [
    {
      'name': 'Tugas Matematika',
      'class': 'Matematika',
      'dueDate': DateTime(2024, 11, 3, 23, 59),
    },
    {
      'name': 'Tugas Bahasa Indonesia',
      'class': 'Bahasa Indonesia',
      'dueDate': DateTime(2024, 10, 15, 23, 59),
    },
    {
      'name': 'Tugas IPA',
      'class': 'IPA',
      'dueDate': DateTime(2023, 10, 7, 23, 59),
    },
    {
      'name': 'Tugas IPS',
      'class': 'IPS',
      'dueDate': DateTime(2024, 10, 7, 23, 00),
    },
    {
      'name': 'Tugas Bahasa Inggris',
      'class': 'Bahasa Inggris',
      'dueDate': DateTime(2024, 10, 8, 23, 55),
    },
    {
      'name': 'Tugas Bahasa',
      'class': 'Bahasa Inggris',
      'dueDate': DateTime(2024, 10, 8, 23, 50),
    },
  ];

  final List<Map<String, String>> _members = [
    {'name': 'Ani Wijaya', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
    {'name': 'Indah Permata', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
    {'name': 'Gibran Rakabuming', 'role': 'Siswa', 'class': 'Bahasa Indonesia'},
    {'name': 'Fajar Ramadhan', 'role': 'Siswa', 'class': 'Bahasa Inggris'},
    {'name': 'Kartika Sari', 'role': 'Siswa', 'class': 'Bahasa Inggris'},
    {'name': 'Kaesang Pangarep', 'role': 'Siswa', 'class': 'Bahasa Inggris'},
    {'name': 'Citra Purnama', 'role': 'Siswa', 'class': 'IPA'},
    {'name': 'Hadi Prasetyo', 'role': 'Siswa', 'class': 'IPA'},
    {'name': 'Megawati Soekarno putri', 'role': 'Siswa', 'class': 'IPA'},
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
                onTap: () => _showStudentSelectionDialog(task),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MissionPage(className: widget.className, onNewNotification: (Notifikasi ) {  },),
                ),
              );
              if (result != null) {
                setState(() {
                  _tasks.add(result);
                });
              }
            },
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

  void _showStudentSelectionDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Siswa'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _members.length,
              itemBuilder: (BuildContext context, int index) {
                final student = _members[index];
                final bool isInClass = student['class'] == widget.className;
                return ListTile(
                  title: Text(student['name']!),
                  subtitle: Text(student['class']!),
                  enabled: isInClass,
                  onTap: isInClass ? () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvaluationPage(
                          taskName: task['name'],
                          studentName: student['name']!,
                          className: widget.className,
                        ),
                      ),
                    );
                  } : null,
                  textColor: isInClass ? null : Colors.grey,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
