import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTaskPage extends StatefulWidget {
  final String className;

  const AddTaskPage({super.key, required this.className});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  late DateTime _dueDate = DateTime.now();
  String? _selectedStudent;
  final TextEditingController _hourController = TextEditingController(text: '00');
  final TextEditingController _minuteController = TextEditingController(text: '00');
  final TextEditingController _descriptionController = TextEditingController();

  // Daftar siswa (sebaiknya diambil dari sumber data yang sesuai)
  final List<String> _students = [
    'Ani Wijaya',
    'Indah Permata',
    'Fajar Ramadhan',
    'Kartika Sari',
    // ... tambahkan siswa lainnya sesuai kelas
  ];

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Tugas'),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Pilih Tanggal Jatuh Tempo'),
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
            const SizedBox(height: 8.0),
            Text(
              'Tanggal Jatuh Tempo: ${_formatDate(_dueDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Pilih Siswa'),
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
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hourController,
                    decoration: const InputDecoration(labelText: 'Jam'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mohon isi jam';
                      }
                      int? hour = int.tryParse(value);
                      if (hour == null || hour < 0 || hour > 23) {
                        return 'Jam harus antara 0-23';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _minuteController,
                    decoration: const InputDecoration(labelText: 'Menit'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mohon isi menit';
                      }
                      int? minute = int.tryParse(value);
                      if (minute == null || minute < 0 || minute > 59) {
                        return 'Menit harus antara 0-59';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Tugas',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon isi deskripsi tugas';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Simpan Tugas'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  int hour = int.parse(_hourController.text);
                  int minute = int.parse(_minuteController.text);
                  Navigator.pop(context, {
                    'name': _taskName,
                    'class': widget.className,
                    'dueDate': DateTime(
                      _dueDate.year,
                      _dueDate.month,
                      _dueDate.day,
                      hour,
                      minute,
                    ),
                    'student': _selectedStudent,
                    'description': _descriptionController.text,
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