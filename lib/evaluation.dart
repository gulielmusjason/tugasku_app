import 'package:flutter/material.dart';

import 'classpagemenu.dart';

class EvaluationPage extends StatefulWidget {
  final String taskName;
  final String studentName;
  final String className;

  const EvaluationPage({
    super.key,
    required this.taskName,
    required this.studentName,
    required this.className,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String? _errorText;

  void _validateAndSave() {
    final score = int.tryParse(_scoreController.text);
    if (score == null || score < 0 || score > 100) {
      setState(() {
        _errorText = 'Masukkan nilai antara 0 dan 100';
      });
    } else {
      setState(() {
        _errorText = null;
      });
      _saveEvaluation();
    }
  }

  void _saveEvaluation() {
    // Simulasi penyimpanan evaluasi
    // Dalam implementasi nyata, Anda akan menyimpan data ke database atau backend
    print('Menyimpan evaluasi:');
    print('Tugas: ${widget.className}');
    print('Siswa: ${widget.studentName}');
    print('Nilai: ${_scoreController.text}');
    print('Feedback: ${_feedbackController.text}');

    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Evaluasi Tersimpan'),
          content: Text('Evaluasi untuk ${widget.studentName} telah berhasil disimpan.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ClassPageMenu()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluasi Tugas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kelas: ${widget.className}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tugas: ${widget.taskName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Siswa: ${widget.studentName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: _scoreController,
              decoration: InputDecoration(
                labelText: 'Nilai',
                border: OutlineInputBorder(),
                errorText: _errorText,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Umpan Balik',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndSave,
              child: Text('Simpan Evaluasi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
