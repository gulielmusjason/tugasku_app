import 'package:flutter/material.dart';
import 'package:tugasku_app/classpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ClassPageMenu extends StatefulWidget {
  const ClassPageMenu({super.key});

  @override
  State<ClassPageMenu> createState() => _ClassPageMenuState();
}

class _ClassPageMenuState extends State<ClassPageMenu> {
  List<Map<String, dynamic>> _classes = [];

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

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = prefs.getString('classes') ?? '[]';
    final classesList = json.decode(classesJson) as List;
    setState(() {
      _classes = classesList.map((classData) {
        return {
          'name': classData['name'],
          'privacy': classData['privacy'],
          'icon': IconData(classData['icon'], fontFamily: 'MaterialIcons'),
        };
      }).toList();
    });
  }

  Future<void> _saveClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = json.encode(_classes.map((classData) {
      return {
        'name': classData['name'],
        'privacy': classData['privacy'],
        'icon': (classData['icon'] as IconData).codePoint,
      };
    }).toList());
    await prefs.setString('classes', classesJson);
  }

  void _tambahKelas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String namaKelas = '';
        IconData selectedIcon = Icons.class_;
        String selectedPrivacy = 'Publik';
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                      value: selectedPrivacy,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPrivacy = newValue!;
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
                      value: selectedIcon,
                      isExpanded: true,
                      onChanged: (IconData? newValue) {
                        setState(() {
                          selectedIcon = newValue!;
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
                          'privacy': selectedPrivacy,
                          'icon': selectedIcon,
                        });
                      });
                      _saveClasses();
                      Navigator.of(context).pop();
                      // Reset state setelah menambah kelas
                      this.setState(() {});
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
