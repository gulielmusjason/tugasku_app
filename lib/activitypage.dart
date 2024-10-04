import 'package:flutter/material.dart';

class Notification {
  final String sender;
  final String message;
  final String time;

  Notification({required this.sender, required this.message, required this.time});
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // Daftar notifikasi sementara
  final List<Notification> notifications = [
    Notification(sender: "ERY DEWAYANI", message: "Guru Matematika", time: "Add Tugas"),
    Notification(sender: "DEDI TRISNAWARMAN", message: "Guru Sejarah", time: "Add Tugas"),
    Notification(sender: "TONY LIE", message: "Guru Kimia", time: "Add Tugas"),
    Notification(sender: "WASINO", message: "Guru Seni", time: "Add Tugas"),
    Notification(sender: "DEBBY", message: "Guru Bahasa Inggris", time: "Add Tugas"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(notification.sender[0]), // Inisial pengirim
            ),
            title: Text(notification.sender),
            subtitle: Text(notification.message),
            trailing: Text(notification.time),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ActivityPage(),
  ));
}