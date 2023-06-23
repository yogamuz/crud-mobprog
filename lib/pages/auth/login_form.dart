import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/auth.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Auth> login(String username, String password) async {
    final response = await http.get(Uri.parse(
        'https://649443970da866a953677178.mockapi.io/users?username=$username&password=$password'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        return Auth.fromJson(responseData[0]);
      } else {
        throw Exception('Invalid username or password');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final String username = usernameController.text;
      final String password = passwordController.text;

      login(username, password).then((auth) {
        // Berhasil login, lakukan navigasi ke halaman Home
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) {
        // Gagal login, tampilkan pesan error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Masuk'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Belum punya akun? Daftar disini!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
