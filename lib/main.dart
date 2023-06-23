import 'package:flutter/material.dart';

import 'pages/anggota/list.dart';
import 'pages/auth/login_form.dart';
import 'pages/auth/register_form.dart';
import 'pages/home.dart';
import 'pages/user/add.dart';
import 'pages/about.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginForm(),
        '/register': (context) => RegisterForm(),
        '/home': (context) => HomePage(),
        '/user/add': (context) => UserAddPage(),
        '/anggota/list': (context) => AnggotaListPage(),
        '/about' : (context) => AboutPage(),
        '/anggota/add': (context) => AnggotaAddPage(),
      },
    );
  }
}
