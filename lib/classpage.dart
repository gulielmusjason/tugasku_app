import 'package:flutter/material.dart';

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
          Stack(
            children: [
              ListView.builder(
                itemCount: _members
                    .where((member) => member['class'] == widget.className)
                    .length,
                itemBuilder: (context, index) {
                  final filteredMembers = _members
                      .where((member) => member['class'] == widget.className)
                      .toList();
                  final member = filteredMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(member['name']![0]),
                    ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final filteredTasks =
        _tasks.where((task) => task['class'] == widget.className).toList();
    filteredTasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));

    final groupedTasks = <DateTime, List<Map<String, dynamic>>>{};
    for (var task in filteredTasks) {
      final dueDate = DateTime(
          task['dueDate'].year, task['dueDate'].month, task['dueDate'].day);
      if (!groupedTasks.containsKey(dueDate)) {
        groupedTasks[dueDate] = [];
      }
      groupedTasks[dueDate]!.add(task);
    }

    final sortedDates = groupedTasks.keys.toList()..sort();

    return Stack(
      children: [
        ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final tasksForDate = groupedTasks[date]!;

            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${date.day} ${_getMonthName(date.month)} ${_getDayName(date)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...tasksForDate.map((task) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(11),
                        onTap: () {},
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
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
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
