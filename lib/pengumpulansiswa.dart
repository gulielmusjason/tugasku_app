import 'package:flutter/material.dart';
import 'dart:math';
import 'evaluation.dart';

class PengumpulanSiswaPage extends StatelessWidget {
  final String className;
  final String taskName;
  final List<Map<String, String>> members;

  const PengumpulanSiswaPage({
    super.key,
    required this.className,
    required this.taskName,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final submittedCount = random.nextInt(members.length);
    final submittedMembers = members.sublist(0, submittedCount);
    final notSubmittedMembers = members.sublist(submittedCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumpulan Tugas'),
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
                  'Kelas: $className',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tugas: $taskName',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  '$submittedCount dari ${members.length} siswa telah mengumpulkan tugas',
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
                      .map((member) => _buildMemberTile(context, member, true)),
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
                  ...notSubmittedMembers.map(
                      (member) => _buildMemberTile(context, member, false)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(
      BuildContext context, Map<String, String> member, bool hasSubmitted) {
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
                className: className,
                itemName: taskName,
                isTask: true,
                studentName: member['name'],
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
}
