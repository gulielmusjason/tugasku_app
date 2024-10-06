import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mission.dart';
import 'pengumpulansiswa.dart';
import 'classpagemenusetting.dart';

class ClassPage extends StatefulWidget {
  final String className;
  final String privacy;
  const ClassPage({
    super.key,
    required this.className,
    required this.privacy,
  });

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, String>> _members = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
    _loadMembers();
    _loadSubmissions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  Future<void> _loadMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final membersJson = prefs.getString('members') ?? '[]';
    final membersList = json.decode(membersJson) as List;
    setState(() {
      _members = membersList
          .map((member) => Map<String, String>.from(member))
          .toList();
    });
  }

  Future<void> _loadSubmissions() async {
    setState(() {});
  }

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

  Future<void> _saveMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final membersJson = json.encode(_members);
    await prefs.setString('members', membersJson);
  }

  void _deleteMember(Map<String, String> member) {
    setState(() {
      _members.remove(member);
    });
    _saveMembers();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${member['name']} telah dihapus dari kelas')),
    );
  }

  void _addNewMember() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        String newRole = 'Siswa';
        return AlertDialog(
          title: const Text('Tambah Anggota Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: const InputDecoration(hintText: "Nama Anggota"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: newRole,
                onChanged: (String? newValue) {
                  setState(() {
                    newRole = newValue!;
                  });
                },
                items: <String>['Siswa', 'Guru', 'Asisten']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Peran',
                ),
              ),
            ],
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
                if (newName.isNotEmpty) {
                  setState(() {
                    _members.add({
                      'name': newName,
                      'role': newRole,
                      'class': widget.className,
                    });
                  });
                  _saveMembers();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '$newName telah ditambahkan ke kelas sebagai $newRole')),
                  );
                }
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          // Refresh state here
          _loadMembers();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassPageMenuSetting(
                      className: widget.className,
                      initialPrivacy: widget.privacy,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      // Refresh state here
                      _loadMembers();
                    });
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Pengaturan'),
              ),
            ],
          ),
        ],
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
      await _saveTasks();
    }
  }

  void _navigateToTaskEvaluation(String taskName) async {
    final filteredMembers = _members
        .where((member) => member['class'] == widget.className)
        .toList();

    final task = _tasks.firstWhere((task) => task['name'] == taskName);
    final taskDescription = task['description'] ?? '';

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengumpulanSiswaPage(
          className: widget.className,
          taskName: taskName,
          taskDescription: taskDescription,
          members: filteredMembers,
          onTaskDeleted: () {
            _loadTasks();
          },
        ),
      ),
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
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteMember(member);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Hapus Anggota'),
                  ),
                ],
              ),
              onTap: () {},
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _addNewMember,
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
