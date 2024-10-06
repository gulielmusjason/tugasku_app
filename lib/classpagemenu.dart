import 'package:flutter/material.dart';
import 'package:tugasku_app/classpage.dart';

class ClassPageMenu extends StatefulWidget {
  const ClassPageMenu({super.key});

  @override
  State<ClassPageMenu> createState() => _ClassPageMenuState();
}

class _ClassPageMenuState extends State<ClassPageMenu> {
  final List<Map<String, dynamic>> _classes = [
    {'name': 'Matematika', 'privacy': 'Publik', 'icon': Icons.calculate},
    {'name': 'Bahasa Indonesia', 'privacy': 'Privat', 'icon': Icons.book},
    {'name': 'IPA', 'privacy': 'Publik', 'icon': Icons.science},
    {'name': 'IPS', 'privacy': 'Privat', 'icon': Icons.public},
    {'name': 'Bahasa Inggris', 'privacy': 'Publik', 'icon': Icons.language},
  ];

  final List<IconData> _availableIcons = [
    Icons.class_,
    Icons.calculate,
    Icons.book,
    Icons.science,
    Icons.public,
    Icons.language,
    Icons.sports_soccer,
    Icons.music_note,
    Icons.palette,
    Icons.computer,
  ];

  IconData _selectedIcon = Icons.class_;
  String _selectedPrivacy = 'Publik';

  void _tambahKelas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String namaKelas = '';
        return AlertDialog(
          title: const Text('Tambah Kelas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Nama Kelas'),
                onChanged: (value) {
                  namaKelas = value;
                },
              ),
              const SizedBox(height: 20),
              const Text('Pilih Privasi:'),
              SizedBox(
                width: double.infinity,
                child: DropdownButton<String>(
                  value: _selectedPrivacy,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPrivacy = newValue!;
                    });
                  },
                  items: <String>['Publik', 'Privat']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Pilih Ikon:'),
              SizedBox(
                width: double.infinity,
                child: DropdownButton<IconData>(
                  value: _selectedIcon,
                  isExpanded: true,
                  onChanged: (IconData? newValue) {
                    setState(() {
                      _selectedIcon = newValue!;
                    });
                  },
                  items: _availableIcons
                      .map<DropdownMenuItem<IconData>>((IconData value) {
                    return DropdownMenuItem<IconData>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(value),
                          const SizedBox(width: 10),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                if (namaKelas.isNotEmpty) {
                  setState(() {
                    _classes.add({
                      'name': namaKelas,
                      'privacy': _selectedPrivacy,
                      'icon': _selectedIcon,
                    });
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mohon isi nama kelas')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _gabungKelas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String kodeKelas = '';
        return AlertDialog(
          title: const Text('Gabung Kelas'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Masukkan Kode Kelas'),
            onChanged: (value) {
              kodeKelas = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gabung'),
              onPressed: () {
                if (kodeKelas.isNotEmpty) {
                  // Implementasi logika untuk bergabung ke kelas
                  // Misalnya, cek kode kelas di database dan tambahkan ke daftar kelas jika valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Bergabung ke kelas dengan kode: $kodeKelas')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mohon masukkan kode kelas')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _pilihAksi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Aksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Kelas'),
                onTap: () {
                  Navigator.of(context).pop();
                  _tambahKelas();
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Gabung Kelas'),
                onTap: () {
                  Navigator.of(context).pop();
                  _gabungKelas();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: _classes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11)),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClassPage(className: _classes[index]['name'])),
                ),
                child: ListTile(
                  leading: Icon(_classes[index]['icon'],
                      color: Theme.of(context).primaryColor, size: 30),
                  title: Text(_classes[index]['name']),
                  subtitle: Text(_classes[index]['privacy']),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pilihAksi,
        child: const Icon(Icons.add),
      ),
    );
  }
}
