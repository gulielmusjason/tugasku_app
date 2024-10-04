import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PengumpulanTugas extends StatefulWidget {
  final String className;
  final String taskName;

  const PengumpulanTugas({
    Key? key,
    required this.className,
    required this.taskName,
  }) : super(key: key);

  @override
  _PengumpulanTugasState createState() => _PengumpulanTugasState();
}

class _PengumpulanTugasState extends State<PengumpulanTugas> {
  String? _fileName;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon pilih file tugas terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulasi proses unggah
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isUploading = false;
    });

    // Panggil fungsi untuk menghapus tugas
    _removeTask();

    _showThankYouDialog();
  }

  void _removeTask() {
    // Implementasi untuk menghapus tugas dari daftar
    // Anda perlu menambahkan logika ini sesuai dengan struktur data Anda
    // Contoh:
    // TaskManager.removeTask(widget.className, widget.taskName);
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terima Kasih'),
          content: Text('Terima kasih sudah mengumpulkan tugas. Tugas ini akan dihapus dari daftar Anda.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(true); // Kembali ke halaman sebelumnya dengan hasil true
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
        title: Text('Pengumpulan Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kelas: ${widget.className}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Tugas: ${widget.taskName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(_fileName ?? 'Pilih File Tugas'),
            ),
            SizedBox(height: 20),
            if (_fileName != null)
              Text('File terpilih: $_fileName', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text('Unggah Tugas'),
            ),
          ],
        ),
      ),
    );
  }
}