import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/user.dart';

class UserAddPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<User> addUser(String username, String password) async {
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
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to add user');
    }
  }

  void submitForm(BuildContext context) {
    final String username = usernameController.text;
    final String password = passwordController.text;

    addUser(username, password).then((user) {
      // Berhasil menambahkan user, kembali ke halaman sebelumnya
      Navigator.pop(context, true);
    }).catchError((error) {
      // Gagal menambahkan user, tampilkan pesan error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the username';
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
                  return 'Please enter the password';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => submitForm(context),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
