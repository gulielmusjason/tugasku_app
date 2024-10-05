import 'package:flutter/material.dart';

import 'evaluation.dart';

class PengumpulanSiswaPage extends StatelessWidget {
  final String className;
  final String taskName;
  final List<Map<String, dynamic>> submissions;

  const PengumpulanSiswaPage({
    Key? key,
    required this.className,
    required this.taskName,
    required this.submissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumpulan Tugas'),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Tugas: $taskName',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(submission['student'][0]),
                  ),
                  title: Text(submission['student']),
                  subtitle: Text('Dikumpulkan: ${_formatDateTime(submission['submissionDate'])}'),
                  trailing: ElevatedButton(
                    child: Text('Evaluasi'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluationPage(
                            className: className,
                            itemName: taskName,
                            isTask: true,
                            studentName: submission['student'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
