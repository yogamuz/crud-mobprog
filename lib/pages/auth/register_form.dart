import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/auth.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Auth> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://649443970da866a953677178.mockapi.io/users'),
      body: json.encode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return Auth.fromJson(responseData);
    } else {
      throw Exception('Failed to register');
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final String username = usernameController.text;
      final String password = passwordController.text;

      register(username, password).then((auth) {
        // Berhasil register, kirim pesan sukses dan kembali ke halaman login
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Register berhasil, silahkan login'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Redirect ke halaman login
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Gagal register, tampilkan pesan error
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
        title: Text('Register'),
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
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
