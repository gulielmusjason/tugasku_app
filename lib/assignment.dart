import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  Future<void> _pilihFile(String mataPelajaran) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _selectedFiles[mataPelajaran] = file;
          _fileTypes[mataPelajaran] = result.files.single.extension!;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File untuk $mataPelajaran berhasil dipilih')),
        );
      } else {
        // Pengguna membatalkan pemilihan file
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemilihan file dibatalkan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
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

