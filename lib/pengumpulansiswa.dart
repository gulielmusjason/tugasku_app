import 'package:flutter/material.dart';
import 'evaluation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PengumpulanSiswaPage extends StatefulWidget {
  final String className;
  final String taskName;
  final String taskDescription;
  final List<Map<String, String>> members;
  final Function() onTaskDeleted;

  const PengumpulanSiswaPage({
    super.key,
    required this.className,
    required this.taskName,
    required this.taskDescription,
    required this.members,
    required this.onTaskDeleted,
  });

  @override
  State<PengumpulanSiswaPage> createState() => _PengumpulanSiswaPageState();
}

class _PengumpulanSiswaPageState extends State<PengumpulanSiswaPage> {
  List<Map<String, String>> submittedMembers = [];
  List<Map<String, String>> notSubmittedMembers = [];

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    // Simulasi data untuk contoh
    setState(() {
      submittedMembers = [
        {'name': 'Budi'},
        {'name': 'Ani'},
      ];
      notSubmittedMembers = [
        {'name': 'Citra'},
        {'name': 'Dodi'},
        {'name': 'Eka'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumpulan Tugas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmationDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Hapus Tugas'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.taskName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  widget.taskDescription,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${submittedMembers.length} dari ${widget.members.length} siswa telah mengumpulkan tugas',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (submittedMembers.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sudah Mengumpulkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...submittedMembers
                      .map((member) => _buildMemberTile(member, true)),
                ],
                if (notSubmittedMembers.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Belum Mengumpulkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...notSubmittedMembers
                      .map((member) => _buildMemberTile(member, false)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(Map<String, String> member, bool hasSubmitted) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(member['name']![0]),
      ),
      title: Text(member['name']!),
      subtitle: hasSubmitted
          ? Text('Dikumpulkan: ${_formatDateTime(DateTime.now())}')
          : const Text('Belum mengumpulkan'),
      trailing: hasSubmitted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.warning, color: Colors.orange),
      onTap: () {
        if (hasSubmitted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvaluationPage(
                className: widget.className,
                itemName: widget.taskName,
                isTask: true,
                studentName: member['name']!,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Siswa belum mengumpulkan tugas')),
          );
        }
      },
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
    return '${date.day} ${monthNames[date.month - 1]} ${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                _deleteTask();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks') ?? '[]';
    final tasksList = json.decode(tasksJson) as List;
    final updatedTasks = tasksList
        .where((task) =>
            task['name'] != widget.taskName ||
            task['class'] != widget.className)
        .toList();
    await prefs.setString('tasks', json.encode(updatedTasks));

    if (mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      widget.onTaskDeleted();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil dihapus')),
      );
    }
  }
}
