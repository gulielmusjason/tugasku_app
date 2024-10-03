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
    Notification(sender: "VALEROY", message: "Selamat sore semua, kalo ada pertanyaan...", time: "14.54"),
    Notification(sender: "DEBBY", message: "Menyebutkan Grup Mahasiswa SI 2022", time: "10.46"),
    Notification(sender: "Dr. Dedi Trisnawarman", message: "Updated an assignment", time: "Yesterday"),
    Notification(sender: "hendra", message: "Scheduled a meeting", time: "Monday"),
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