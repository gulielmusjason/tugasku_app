import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluationPage extends StatefulWidget {
  final String className;
  final String itemName;
  final bool isTask;
  final String? studentName;

  const EvaluationPage({
    super.key,
    required this.className,
    required this.itemName,
    this.isTask = false,
    this.studentName,
  });

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  String _feedback = '';
  late String _selectedStudent;
  String? _submittedFile;

  @override
  void initState() {
    super.initState();
    _selectedStudent = widget.studentName ?? '';
    _submittedFile = 'Tugas_Matematika_Ani_Wijaya.pdf';
  }

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
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.isTask ? widget.itemName : widget.itemName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(widget.studentName ?? 'Nama Siswa Tidak Tersedia',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _scoreController,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                _submittedFile != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'File yang dikumpulkan:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _submittedFile!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  // Implementasi logika download di sini
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Mengunduh file...')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : Container(),
                ElevatedButton(
                  onPressed: _submitEvaluation,
                  child: const Text('Kirim Evaluasi'),
                ),
              ],
            ),
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
        const SnackBar(content: Text('Evaluasi berhasil disimpan')),
      );
      Navigator.pop(context,
          {'student': _selectedStudent, 'score': score, 'feedback': _feedback});
    }
  }
}
