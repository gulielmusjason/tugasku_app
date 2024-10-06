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
      appBar: _buildAppBar(),
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

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: _buildTabButton('Mendatang', 0)),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton('Lewat Jatuh Tempo', 1)),
              const SizedBox(width: 8),
              Expanded(child: _buildTabButton('Selesai', 2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _tabController.index == index
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(5),
        ),
        onPressed: () {
          _tabController.animateTo(index);
          setState(() {});
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildTaskList(String status) {
    final List<Map<String, dynamic>> tasks = _getTasks();
    tasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));

    final groupedTasks = _groupTasksByDate(tasks);
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

        return _buildTaskGroup(date, filteredTasks);
      },
    );
  }

  Widget _buildTaskGroup(DateTime date, List<Map<String, dynamic>> tasks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day} ${_getMonthName(date.month)} ${_getDayName(date)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ...tasks.map((task) => _buildTaskCard(task)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final taskStatus = _getTaskStatus(
        task['dueDate'], task['isSubmitted'], task['submittedDate']);
    final isLateOrOverdue =
        taskStatus == 'Lewat Jatuh Tempo' || taskStatus == 'Telat';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: () => _navigateToPengumpulanTugas(task),
        child: ListTile(
          leading: _getClassIcon(task['class']),
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
              if (task['isSubmitted'] && task['submittedDate'] != null)
                Text(
                  'Disubmit pada: ${_formatDateTime(task['submittedDate'])}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              Text(
                taskStatus,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLateOrOverdue ? Colors.red : null,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getClassIcon(String className) {
    switch (className.toLowerCase()) {
      case 'matematika':
        return Icon(Icons.calculate, color: Theme.of(context).primaryColor);
      case 'bahasa indonesia':
        return Icon(Icons.book, color: Theme.of(context).primaryColor);
      case 'ipa':
        return Icon(Icons.science, color: Theme.of(context).primaryColor);
      case 'ips':
        return Icon(Icons.public, color: Theme.of(context).primaryColor);
      case 'bahasa inggris':
        return Icon(Icons.language, color: Theme.of(context).primaryColor);
      default:
        return Icon(Icons.class_, color: Theme.of(context).primaryColor);
    }
  }

  void _navigateToPengumpulanTugas(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengumpulanTugas(task: task),
      ),
    );
  }

  List<Map<String, dynamic>> _getTasks() {
    return [
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
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupTasksByDate(
      List<Map<String, dynamic>> tasks) {
    final groupedTasks = <DateTime, List<Map<String, dynamic>>>{};
    for (var task in tasks) {
      final dueDate = DateTime(
          task['dueDate'].year, task['dueDate'].month, task['dueDate'].day);
      if (!groupedTasks.containsKey(dueDate)) {
        groupedTasks[dueDate] = [];
      }
      groupedTasks[dueDate]!.add(task);
    }
    return groupedTasks;
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
