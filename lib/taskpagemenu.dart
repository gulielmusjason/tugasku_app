import 'package:flutter/material.dart';
import 'package:tugasku_app/pengumpulantugas.dart';

class TaskPageMenu extends StatefulWidget {
  const TaskPageMenu({super.key});

  @override
  State<TaskPageMenu> createState() => _TaskPageMenuState();
}

class _TaskPageMenuState extends State<TaskPageMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(child: Text('Mendatang', textAlign: TextAlign.center)),
          Tab(child: Text('Lewat Jatuh Tempo', textAlign: TextAlign.center)),
          Tab(child: Text('Selesai', textAlign: TextAlign.center)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList('Mendatang'),
          _buildTaskList('Lewat Jatuh Tempo'),
          _buildTaskList('Selesai'),
        ],
      ),
    );
  }

  Widget _buildTaskList(String status) {
    final List<Map<String, dynamic>> tasks = [
      {
        'name': 'Tugas Matematika',
        'class': 'Matematika',
        'dueDate': DateTime(2024, 11, 3, 23, 59),
        'isSubmitted': false,
        'submittedDate': null
      },
      {
        'name': 'Tugas Bahasa Indonesia',
        'class': 'Bahasa Indonesia',
        'dueDate': DateTime(2024, 10, 15, 23, 59),
        'isSubmitted': false,
        'submittedDate': null
      },
      {
        'name': 'Tugas IPA',
        'class': 'IPA',
        'dueDate': DateTime(2023, 10, 7, 23, 59),
        'isSubmitted': false,
        'submittedDate': null
      },
      {
        'name': 'Tugas IPS',
        'class': 'IPS',
        'dueDate': DateTime(2024, 10, 7, 23, 00),
        'isSubmitted': true,
        'submittedDate': DateTime(2024, 10, 7, 23, 30)
      },
      {
        'name': 'Tugas Bahasa Inggris',
        'class': 'Bahasa Inggris',
        'dueDate': DateTime(2024, 10, 8, 23, 55),
        'isSubmitted': true,
        'submittedDate': DateTime(2024, 10, 8, 23, 00)
      },
      {
        'name': 'Tugas Bahasa',
        'class': 'Bahasa Inggris',
        'dueDate': DateTime(2024, 10, 8, 23, 50),
        'isSubmitted': true,
        'submittedDate': DateTime(2024, 10, 8, 23, 56)
      },
    ];

    tasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));

    final groupedTasks = <DateTime, List<Map<String, dynamic>>>{};
    for (var task in tasks) {
      final dueDate = DateTime(
          task['dueDate'].year, task['dueDate'].month, task['dueDate'].day);
      if (!groupedTasks.containsKey(dueDate)) {
        groupedTasks[dueDate] = [];
      }
      groupedTasks[dueDate]!.add(task);
    }

    final sortedDates = groupedTasks.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final tasksForDate = groupedTasks[date]!;

        final filteredTasks = tasksForDate
            .where((task) =>
                _getTaskStatusTab(task['dueDate'], task['isSubmitted']) ==
                status)
            .toList();

        if (filteredTasks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day} ${_getMonthName(date.month)} ${_getDayName(date)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...filteredTasks.map((task) {
                final taskStatus = _getTaskStatus(task['dueDate'],
                    task['isSubmitted'], task['submittedDate']);
                final isLateOrOverdue =
                    taskStatus == 'Lewat Jatuh Tempo' || taskStatus == 'Telat';
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(11),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PengumpulanTugas(task: task),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(task['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${task['class']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Jatuh tempo: ${_formatDateTime(task['dueDate'])}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (task['isSubmitted'] &&
                              task['submittedDate'] != null)
                            Text(
                              'Disubmit pada: ${_formatDateTime(task['submittedDate'])}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          Text(
                            taskStatus,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: isLateOrOverdue ? Colors.red : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getTaskStatusTab(DateTime dueDate, bool isSubmitted) {
    final now = DateTime.now();
    if (!isSubmitted && now.isAfter(dueDate)) {
      return 'Lewat Jatuh Tempo';
    } else if (isSubmitted) {
      return 'Selesai';
    } else {
      return 'Mendatang';
    }
  }

  String _getTaskStatus(
      DateTime dueDate, bool isSubmitted, DateTime? submittedDate) {
    final now = DateTime.now();
    if (!isSubmitted && now.isAfter(dueDate)) {
      return 'Lewat Jatuh Tempo';
    } else if (isSubmitted) {
      return submittedDate != null && submittedDate.isAfter(dueDate)
          ? 'Telat'
          : 'Selesai';
    } else {
      return 'Mendatang';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
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
    return monthNames[month - 1];
  }

  String _getDayName(DateTime date) {
    const dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return dayNames[date.weekday - 1];
  }
}
