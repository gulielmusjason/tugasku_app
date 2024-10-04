import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class PengumpulanTugas extends StatefulWidget {
  const PengumpulanTugas({Key? key}) : super(key: key);

  @override
  _PengumpulanTugasState createState() => _PengumpulanTugasState();
}

class _PengumpulanTugasState extends State<PengumpulanTugas> {
  Map<String, File?> _selectedFiles = {};
  Map<String, String> _fileTypes = {};
  Map<String, bool> _isUploading = {};

  final String _targetFolder = r'C:\Users\Documents\images';

  Future<void> _pilihFile(String mataPelajaran) async {
    final result = await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return _FilePickerDialog(targetFolder: _targetFolder);
      },
    );

    if (result != null) {
      setState(() {
        _selectedFiles[mataPelajaran] = result;
        _fileTypes[mataPelajaran] = path.extension(result.path).toLowerCase().replaceFirst('.', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File untuk $mataPelajaran berhasil dipilih')),
      );
    }
  }

  Future<void> _unggahFile(String mataPelajaran) async {
    if (_selectedFiles[mataPelajaran] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih file untuk $mataPelajaran terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isUploading[mataPelajaran] = true;
    });

    // Simulasi proses pengunggahan
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading[mataPelajaran] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File untuk $mataPelajaran berhasil diunggah')),
    );

    // Reset file yang dipilih setelah berhasil diunggah
    setState(() {
      _selectedFiles[mataPelajaran] = null;
      _fileTypes[mataPelajaran] = '';
    });
  }

  Widget _tampilkanPreview(String mataPelajaran) {
    if (_selectedFiles[mataPelajaran] == null) {
      return const Text('Belum ada file yang dipilih');
    }

    switch (_fileTypes[mataPelajaran]) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, size: 100);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Image.file(_selectedFiles[mataPelajaran]!, height: 200);
      case 'mp4':
        return const Icon(Icons.video_file, size: 100);
      default:
        return const Text('Format file tidak didukung');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumpulan Tugas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTugasCard(
              'Matematika',
              'Tugas Akhir Semester',
              '30 Juni 2024',
            ),
            const SizedBox(height: 16),
            _buildTugasCard(
              'IPA',
              'Proyek Penelitian Sederhana',
              '15 Juli 2024',
            ),
            const SizedBox(height: 16),
            _buildTugasCard(
              'Bahasa Indonesia',
              'Esai Analisis Karya Sastra',
              '20 Juli 2024',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasCard(String mataPelajaran, String judulTugas, String tenggatWaktu) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mataPelajaran,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Judul Tugas: $judulTugas'),
            Text('Tenggat Waktu: $tenggatWaktu'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _pilihFile(mataPelajaran),
              icon: const Icon(Icons.file_upload),
              label: const Text('Pilih File'),
            ),
            if (_selectedFiles[mataPelajaran] != null) ...[
              const SizedBox(height: 8),
              Text('File terpilih: ${path.basename(_selectedFiles[mataPelajaran]!.path)}'),
            ],
            const SizedBox(height: 16),
            _tampilkanPreview(mataPelajaran),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectedFiles[mataPelajaran] != null && _isUploading[mataPelajaran] != true
                  ? () => _unggahFile(mataPelajaran)
                  : null,
              icon: _isUploading[mataPelajaran] == true
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isUploading[mataPelajaran] == true ? 'Mengunggah...' : 'Unggah Tugas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilePickerDialog extends StatelessWidget {
  final String targetFolder;

  const _FilePickerDialog({Key? key, required this.targetFolder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final directory = Directory(targetFolder);
    final files = directory.listSync().whereType<File>().toList();

    return AlertDialog(
      title: Text('Pilih File dari $targetFolder'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final fileName = path.basename(file.path);
            return ListTile(
              leading: Icon(_getFileIcon(fileName)),
              title: Text(fileName),
              onTap: () {
                Navigator.of(context).pop(file);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}

