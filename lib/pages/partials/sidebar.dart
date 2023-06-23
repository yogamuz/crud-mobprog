import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'MyOrmawa',
                style: TextStyle(
                  color: Color.fromARGB(255, 219, 215, 215),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            selected: ModalRoute.of(context)?.settings.name == '/home',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('Data'),
            selected: ModalRoute.of(context)?.settings.name == '/anggota/list',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/anggota/list');
            },
          ),
          ListTile(
            title: Text('Tentang'),
            selected: ModalRoute.of(context)?.settings.name == '/about',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Tambahkan logika logout di sini
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
