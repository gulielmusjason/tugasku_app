import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
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
          Tab(text: 'Mendatang'),
          Tab(
            child: Text(
              'Lewat Jatuh Tempo',
              textAlign: TextAlign.center,
            ),
          ),
          Tab(text: 'Selesai'),
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
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...tasks.map((task) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(task),
                      subtitle: Text('Deskripsi $task'),
                      trailing: Text(status),
                    ),
                  ),
                )),
            const Divider(),
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
