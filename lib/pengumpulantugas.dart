import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class PengumpulanTugas extends StatefulWidget {
  final Map<String, dynamic> task;

  const PengumpulanTugas({super.key, required this.task});

  @override
  State<PengumpulanTugas> createState() => _PengumpulanTugasState();
}

class _PengumpulanTugasState extends State<PengumpulanTugas> {
  File? _selectedFile;
  String _fileType = '';
  bool _isUploading = false;

  Future<void> _pilihFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileType = result.files.single.extension!;
        });
        _showSnackBar('File berhasil dipilih');
      } else {
        _showSnackBar('Pemilihan file dibatalkan');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    }
  }

  Future<void> _unggahFile() async {
    if (_selectedFile == null) {
      _showSnackBar('Pilih file terlebih dahulu');
      return;
    }

    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isUploading = false;
      _selectedFile = null;
      _fileType = '';
    });
    _showSnackBar('File berhasil diunggah');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumpulan Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTugasCard(
              widget.task['name'],
              widget.task['class'],
              _formatDateTime(widget.task['dueDate']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tampilkanPreview() {
    if (_selectedFile == null) return const Text('Belum ada file yang dipilih');

    switch (_fileType) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, size: 30);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Image.file(_selectedFile!, height: 100);
      default:
        return const Text('Format file tidak didukung');
    }
  }

  Widget _buildTugasCard(
      String judulTugas, String mataPelajaran, String tenggatWaktu) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judulTugas,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(mataPelajaran),
            Text('Jatuh Tempo: $tenggatWaktu'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pilihFile,
              icon: const Icon(Icons.file_upload),
              label: const Text('Pilih File'),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 8),
              Text('File terpilih: ${path.basename(_selectedFile!.path)}'),
            ],
            const SizedBox(height: 16),
            _tampilkanPreview(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed:
                  _selectedFile != null && !_isUploading ? _unggahFile : null,
              icon: _isUploading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isUploading ? 'Mengunggah...' : 'Unggah Tugas'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return monthNames[month];
  }
}
