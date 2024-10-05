import 'package:flutter/material.dart';

class Kosong extends StatelessWidget {
  const Kosong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Kosongs'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman kosong'),
      ),
    );
  }
}
