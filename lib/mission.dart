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
  String? _selectedStudent;

  // Daftar siswa (sebaiknya diambil dari sumber data yang sesuai)
  final List<String> _students = [
    'Ani Wijaya',
    'Indah Permata',
    'Fajar Ramadhan',
    'Kartika Sari',
    // ... tambahkan siswa lainnya sesuai kelas
  ];

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
            SizedBox(height: 8.0),
            Text(
              'Tanggal Jatuh Tempo: ${_formatDate(_dueDate)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Pilih Siswa'),
              value: _selectedStudent,
              items: _students.map((String student) {
                return DropdownMenuItem<String>(
                  value: student,
                  child: Text(student),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStudent = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon pilih siswa';
                }
                return null;
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
                    'student': _selectedStudent,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
