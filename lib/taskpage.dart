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
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Tugas $index'),
              subtitle: Text('Deskripsi tugas $index'),
              trailing: Text(status),
            ),
          ),
        );
      },
    );
  }
}
