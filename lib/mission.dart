import 'package:flutter/material.dart';

import 'notifpagemenu.dart';

export 'mission.dart';

class MissionPage extends StatefulWidget {
  final String className;
  final Function(Notifikasi) onNewNotification;

  const MissionPage({
    Key? key, 
    required this.className,
    required this.onNewNotification,
  }) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(Duration(days: 7));

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      // Simpan tugas baru
      final newTask = {
        'name': _taskNameController.text,
        'class': widget.className,
        'dueDate': _dueDate,
      };

      // Buat notifikasi baru
      final newNotification = Notifikasi(
        pengirim: "Sistem",
        pesan: "Tugas baru '${newTask['name']}' telah ditambahkan untuk kelas ${newTask['class']}",
        waktu: DateTime.now(),
        isDeadline: true,
      );

      // Kirim notifikasi baru
      widget.onNewNotification(newNotification);

      // Kembali ke ClassPage dengan tugas baru
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas - ${widget.className}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(labelText: 'Nama Tugas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi nama tugas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Tanggal Jatuh Tempo:'),
              ListTile(
                title: Text(_dueDate.toString()),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Tambah Tugas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
