import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    Navigator.pushNamed(
      context,
      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuració"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Mode Fosc"),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),
            ListTile(
              title: Text("Tancar sessió"),
              leading: Icon(Icons.logout), // Icona a l'esquerra per millorar la UI
              onTap: () => _logout(context), // Fa que tota la Tile sigui clicable
            ),
          ],
        ),
      ),
    );
  }
}
