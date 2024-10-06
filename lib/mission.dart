import 'package:flutter/material.dart';

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
  TimeOfDay _dueTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas Baru'),
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Form(
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Jatuh Tempo:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          _formatDate(_dueDate),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
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
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Waktu Jatuh Tempo:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          _dueTime.format(context),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _dueTime,
                      );
                      if (picked != null && picked != _dueTime) {
                        setState(() {
                          _dueTime = picked;
                        });
                      }
                    },
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
                    Navigator.pop(context, {
                      'name': _taskName,
                      'class': widget.className,
                      'dueDate': DateTime(
                        _dueDate.year,
                        _dueDate.month,
                        _dueDate.day,
                        _dueTime.hour,
                        _dueTime.minute,
                      ),
                      'description': _descriptionController.text,
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
