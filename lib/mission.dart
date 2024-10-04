import 'package:flutter/material.dart';

export 'mission.dart';

class MissionPage extends StatefulWidget {
  final String? className;
  final List<String>? classes;
  final Function(Map<String, dynamic>) onNewTask;

  const MissionPage({
    Key? key,
    this.className,
    this.classes,
    required this.onNewTask,
  }) : assert(className != null || classes != null),
       super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(Duration(days: 7));
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.className ?? widget.classes?.first;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        'name': _taskNameController.text,
        'class': _selectedClass!,
        'dueDate': _dueDate,
      };

      widget.onNewTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas${widget.className != null ? ' - ${widget.className}' : ''}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.classes != null)
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  items: widget.classes!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClass = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Pilih Kelas'),
                ),
              SizedBox(height: 20), // Tambahkan padding di sini
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
