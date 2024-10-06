import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassPageMenuSetting extends StatefulWidget {
  final String className;
  final String initialPrivacy;

  const ClassPageMenuSetting({
    super.key,
    required this.className,
    required this.initialPrivacy,
  });

  @override
  State<ClassPageMenuSetting> createState() => _ClassPageMenuSettingState();
}

class _ClassPageMenuSettingState extends State<ClassPageMenuSetting> {
  late String _currentPrivacy;
  late String _currentClassName;
  final TextEditingController _classNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPrivacy = widget.initialPrivacy;
    _currentClassName = widget.className;
    _classNameController.text = _currentClassName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Kelas'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Ubah Nama Kelas'),
            leading: const Icon(Icons.edit),
            trailing: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                setState(() {
                  _currentClassName = _classNameController.text;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama kelas berhasil diubah')),
                );
              },
            ),
            subtitle: TextField(
              controller: _classNameController,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama kelas baru',
              ),
            ),
          ),
          ListTile(
            title: const Text('Ubah Privasi'),
            leading: const Icon(Icons.privacy_tip),
            trailing: DropdownButton<String>(
              value: _currentPrivacy,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentPrivacy = newValue;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Privasi kelas berhasil diubah')),
                  );
                }
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
          ListTile(
            title: const Text('Hapus Kelas'),
            leading: const Icon(Icons.delete),
            onTap: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text(
              'Apakah Anda yakin ingin menghapus kelas $_currentClassName?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteClass();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteClass() async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = prefs.getString('classes') ?? '[]';
    final classesList = json.decode(classesJson) as List;

    classesList
        .removeWhere((classData) => classData['name'] == _currentClassName);

    await prefs.setString('classes', json.encode(classesList));

    if (mounted) {
      Navigator.of(context).pop({'classDeleted': true});
      Navigator.of(context).pop({'classDeleted': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas berhasil dihapus')),
      );
    }
  }
}
