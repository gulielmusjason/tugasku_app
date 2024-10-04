import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PengumpulanTugas extends StatefulWidget {
  const PengumpulanTugas({Key? key}) : super(key: key);

  @override
  _PengumpulanTugasState createState() => _PengumpulanTugasState();
}

class _PengumpulanTugasState extends State<PengumpulanTugas> {
  File? _selectedFile;
  String _fileType = '';

  Future<void> _pilihFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileType = result.files.single.extension!;
      });
    }
  }

  Widget _tampilkanPreview() {
    if (_selectedFile == null) {
      return const Text('Belum ada file yang dipilih');
    }

    switch (_fileType) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, size: 100);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Image.file(_selectedFile!, height: 200);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pilihFile,
              child: const Text('Pilih File'),
            ),
            const SizedBox(height: 20),
            _tampilkanPreview(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedFile != null
                  ? () {
                      // Implementasi logika untuk mengunggah file
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File berhasil diunggah')),
                      );
                    }
                  : null,
              child: const Text('Unggah Tugas'),
            ),
          ],
        ),
      ),
    );
  }
}
