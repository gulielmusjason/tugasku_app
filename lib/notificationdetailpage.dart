import 'package:flutter/material.dart';
import 'notificationpagemenu.dart';

class NotificationDetailPage extends StatelessWidget {
  final Notifikasi notifikasi;

  const NotificationDetailPage({super.key, required this.notifikasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notifikasi.namaKelas,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notifikasi.pesan,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Waktu: ${notifikasi.waktu.toString()}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Tipe: ${_getTipeNotifikasi(notifikasi.tipe)}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTipeNotifikasi(TipeNotifikasi tipe) {
    switch (tipe) {
      case TipeNotifikasi.nilaiTugas:
        return 'Nilai Tugas';
      case TipeNotifikasi.tugasBaru:
        return 'Tugas Baru';
      case TipeNotifikasi.deadlineTugas:
        return 'Deadline Tugas';
      case TipeNotifikasi.lainnya:
        return 'Lainnya';
    }
  }
}
