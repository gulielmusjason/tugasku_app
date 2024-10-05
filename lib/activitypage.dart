import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    final Map<DateTime, List<String>> tasksByDate = {
      DateTime(2023, 10, 3): [
        'Tugas Matematika',
        'Presentasi Sejarah',
        'Laporan Kimia'
      ],
      DateTime(2023, 10, 4): ['Proyek Seni', 'Kuis Bahasa Inggris'],
    };

    return ListView.builder(
      itemCount: tasksByDate.length,
      itemBuilder: (context, index) {
        final date = tasksByDate.keys.elementAt(index);
        final tasks = tasksByDate[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${date.day} ${_getMonthName(date.month)} ${date.year}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...tasks.map((task) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: Text(task),
                    subtitle: Text('Deskripsi $task'),
                    trailing: const Text('Status'), // You can change this if needed
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return monthNames[month - 1];
  }
}