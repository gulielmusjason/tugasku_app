import 'package:flutter/material.dart';

class Notifikasi {
  final String pengirim;
  final String pesan;
  final DateTime waktu;
  final bool isDeadline;
  final bool isNilai;

  Notifikasi({
    required this.pengirim,
    required this.pesan,
    required this.waktu,
    this.isDeadline = false,
    this.isNilai = false,
  });
}

class NotificationPageMenu extends StatefulWidget {
  const NotificationPageMenu({super.key});

  @override
  State<NotificationPageMenu> createState() => _NotificationPageMenuState();
}

class _NotificationPageMenuState extends State<NotificationPageMenu> {
  final List<Notifikasi> notifikasi = [
    Notifikasi(
      pengirim: "Pak Budi",
      pesan: "Tugas matematika baru telah ditambahkan untuk minggu ini",
      waktu: DateTime(2023, 10, 8, 23, 50),
      isDeadline: true,
    ),
    Notifikasi(
      pengirim: "Ibu Siti",
      pesan: "Rapat penting untuk semua siswa kelas Bahasa Indonesia",
      waktu: DateTime(2024, 8, 8, 19, 50),
    ),
    Notifikasi(
      pengirim: "Pak Andi",
      pesan: "Batas waktu pengumpulan tugas IPA diperpanjang",
      waktu: DateTime(2024, 9, 27, 20, 10),
      isDeadline: true,
    ),
    Notifikasi(
      pengirim: "Mr. John",
      pesan: "Kelas Bahasa Inggris hari ini akan diadakan secara online",
      waktu: DateTime(2024, 10, 5, 00, 42),
    ),
    Notifikasi(
      pengirim: "Sistem",
      pesan: "Nilai tugas Matematika telah diumumkan",
      waktu: DateTime(2024, 10, 6, 14, 30),
      isNilai: true,
    ),
  ];

  bool _isAscending = false;

  @override
  void initState() {
    super.initState();
    _sortNotifikasi();
  }

  void _sortNotifikasi() {
    setState(() {
      notifikasi.sort((a, b) => b.waktu.compareTo(a.waktu));
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      notifikasi.sort((a, b) => _isAscending
          ? a.waktu.compareTo(b.waktu)
          : b.waktu.compareTo(a.waktu));
    });
  }

  String _formatWaktu(DateTime waktu) {
    final sekarang = DateTime.now();
    final selisih = sekarang.difference(waktu);

    if (selisih.inMinutes < 1) {
      return 'Baru saja';
    } else if (selisih.inMinutes < 60) {
      return '${selisih.inMinutes} menit yang lalu';
    } else if (selisih.inHours < 24) {
      return '${selisih.inHours} jam yang lalu';
    } else if (selisih.inDays == 1) {
      return 'Kemarin';
    } else if (selisih.inDays < 7) {
      return _getNamaHari(waktu);
    } else if (sekarang.year == waktu.year) {
      return '${waktu.day} ${_getNamaBulan(waktu.month)}';
    } else {
      return '${waktu.day} ${_getNamaBulan(waktu.month)} ${waktu.year}';
    }
  }

  String _getNamaHari(DateTime tanggal) {
    const namaHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return namaHari[tanggal.weekday - 1];
  }

  String _getNamaBulan(int bulan) {
    const namaBulan = [
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
    return namaBulan[bulan - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ElevatedButton(
          onPressed: _toggleSortOrder,
          style: ElevatedButton.styleFrom(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
              const SizedBox(width: 8),
              Text(_isAscending ? "Terlama" : "Terbaru"),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifikasi.length,
        itemBuilder: (context, index) {
          final notif = notifikasi[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: notif.isDeadline
                  ? Colors.orange
                  : notif.isNilai
                      ? Colors.green
                      : Theme.of(context).primaryColor,
              child: Icon(
                notif.isDeadline
                    ? Icons.timer
                    : notif.isNilai
                        ? Icons.grade
                        : Icons.notifications,
                color: Colors.white,
              ),
            ),
            title: Text(notif.pengirim),
            subtitle: Text(notif.pesan),
            trailing: Text(_formatWaktu(notif.waktu)),
            onTap: () {},
          );
        },
      ),
    );
  }
}
