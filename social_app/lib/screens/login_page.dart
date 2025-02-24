import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sessió")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    validator: (text) {
                      if (text!.isEmpty) return "Correu és obligatori";
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Correu electrònic"),
                    onSaved: (text) => _email = text,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text!.isEmpty) return "Contrasenya és obligatori";
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Contrasenya"),
                    obscureText: true,
                    onSaved: (text) => _password = text,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  _key.currentState!.save();
                  await loginProvider.loginOrRegister(_email!, _password!);
                  if (loginProvider.accesGranted) {
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loginProvider.errorMessage)),
                    );
                  }
                }
              },
              child: Text("Iniciar Sessió"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("No tens compte? Registra't aquí"),
            ),
            if (loginProvider.isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
