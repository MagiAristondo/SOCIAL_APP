import 'package:flutter/material.dart';
import '../providers/api_provider.dart';
import '../models/missatge.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _messageController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _submitPost() async {
    if (_messageController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'El missatge no pot estar buit';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    Missatge newMessage = Missatge(
      id: 0, // L'ID es genera automàticament a la BD
      text: _messageController.text.trim(),
      dataHora: DateTime.now(),
      likes: 0,
      dislikes: 0,
      latitud: 0.0, // Placeholder de moment
      longitud: 0.0, // Placeholder de moment
    );

    try {
      bool success = await ApiProvider().createMissatge(newMessage);
      
      setState(() {
        _isLoading = false;
      });
      
      if (success) {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Error en publicar el missatge';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nou Missatge')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Escriu el teu missatge'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitPost,
                    child: Text('Publicar'),
                  ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
