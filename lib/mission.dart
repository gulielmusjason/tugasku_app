import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  final String className;

  const AddTaskPage({Key? key, required this.className}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  late DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nama Tugas'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon isi nama tugas';
                }
                return null;
              },
              onSaved: (value) {
                _taskName = value!;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Pilih Tanggal Jatuh Tempo'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _dueDate) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Simpan Tugas'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context, {
                    'name': _taskName,
                    'class': widget.className,
                    'dueDate': _dueDate,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
