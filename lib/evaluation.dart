import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluationPage extends StatefulWidget {
  final String className;
  final String itemName;
  final bool isTask;

  const EvaluationPage({
    Key? key,
    required this.className,
    required this.itemName,
    this.isTask = false,
  }) : super(key: key);

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  String _feedback = '';
  String _selectedStudent = ''; // Tambahkan variabel ini

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluasi ${widget.className}'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isTask ? 'Tugas: ${widget.itemName}' : 'Siswa: ${widget.itemName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              // Tambahkan dropdown untuk memilih siswa
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Siswa',
                  border: OutlineInputBorder(),
                ),
                value: _selectedStudent.isEmpty ? null : _selectedStudent,
                items: [
                  'Ani Wijaya',
                  'Indah Permata',
                  'Fajar Ramadhan',
                  'Kartika Sari',
                  // ... tambahkan siswa lainnya sesuai kelas
                ].map((String student) {
                  return DropdownMenuItem<String>(
                    value: student,
                    child: Text(student),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStudent = newValue ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon pilih siswa';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _scoreController,
                decoration: InputDecoration(
                  labelText: 'Nilai (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan nilai';
                  }
                  int? score = int.tryParse(value);
                  if (score == null || score < 0 || score > 100) {
                    return 'Nilai harus antara 0 dan 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi feedback';
                  }
                  return null;
                },
                onSaved: (value) {
                  _feedback = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEvaluation,
                child: Text('Kirim Evaluasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitEvaluation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int score = int.parse(_scoreController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evaluasi berhasil disimpan')),
      );
      Navigator.pop(context, {
        'student': _selectedStudent,
        'score': score,
        'feedback': _feedback
      });
    }
  }
}
