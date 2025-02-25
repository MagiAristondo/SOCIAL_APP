import 'package:flutter/material.dart';
import '../models/missatge.dart';
import '../providers/api_provider.dart';
import '../routes/app_router.dart';
import '../widgets/missatge_item.dart';

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
      print("Error carregant missatges: $e");
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
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : RefreshIndicator(
                  onRefresh: _carregarMissatges, // La funció per refrescar
                  child: ListView.builder(
                    itemCount: missatges.length,
                    itemBuilder: (context, index) {
                      final missatge = missatges[index];
                      return MissatgeItem(
                        missatge: missatge,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/messageDetail',
                            arguments: missatge,
                          );
                        },
                        onLikeDislike: _carregarMissatges(),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultat = await Navigator.pushNamed(context, '/newPost');
          if (resultat == true) {
            _carregarMissatges();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
