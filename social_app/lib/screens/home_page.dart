import 'package:flutter/material.dart';
import '../models/missatge.dart';
import '../providers/api_provider.dart';
import '../routes/app_router.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Missatge> missatges = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _carregarMissatges();
  }

  Future<void> _carregarMissatges() async {
    try {
      List<Missatge> response = await ApiProvider().getMissatges();
      setState(() {
        missatges = response;
        _isLoading = false;
      });
    } catch (e) {
      print("Error carregant missatges: $e"); // <-- Afegit per veure l'error
      setState(() {
        _errorMessage = 'Error carregant missatges: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Missatges propers"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: missatges.length,
                  itemBuilder: (context, index) {
                    final missatge = missatges[index];
                    return ListTile(
                      title: Text(missatge.text),
                      subtitle: Text("${missatge.likes} Likes - ${missatge.dislikes} Dislikes"),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/messageDetail',
                          arguments: missatge,
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newPost');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
