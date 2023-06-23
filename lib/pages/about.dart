import 'package:flutter/material.dart';
import 'partials/sidebar.dart';

class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              'Aplikasi ini dibuat untuk memenuhi tugas mata kuliah Pemrograman Mobile dan dibuat dengan menggunakan Flutter dan Dart oleh Kelompok 1',
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      drawer: Sidebar(),
    );
  }
}
