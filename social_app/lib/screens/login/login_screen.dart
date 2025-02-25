import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('username', usernameController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
    Navigator.pushNamed(
      context,
      '/',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Usuari'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contrasenya'),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text('Recordar credencials')
              ],
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}