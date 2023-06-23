import 'package:flutter/material.dart';
import 'partials/sidebar.dart';

class HomePage extends StatelessWidget {
  final String greeting;

  HomePage() : greeting = _getGreeting();

  static String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Selamat pagi';
    } else if (hour < 15) {
      return 'Selamat siang';
    } else if (hour < 18) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              greeting,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            // Deskripsi aplikasi
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Selamat datang di aplikasi MyOrmawa, aplikasi ini dibuat untuk mengelola data anggota ormawa',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk tambah data
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/anggota/add');
              },
              child: Text('Tambah Data'),
            ),
          ],
        ),
      ),
      drawer: Sidebar(), // Menambahkan Sidebar ke dalam drawer
    );
  }
}
