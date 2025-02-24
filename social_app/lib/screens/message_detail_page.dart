import 'package:flutter/material.dart';
import '../models/missatge.dart';
import '../models/comentari.dart';

class MessageDetailPage extends StatefulWidget {
  final Missatge missatge;

  const MessageDetailPage({Key? key, required this.missatge}) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  List<Comentari> comentaris = [];

  @override
  void initState() {
    super.initState();
    _carregarComentaris();
  }

  Future<void> _carregarComentaris() async {
    // Aquí es faria la crida a l'API per obtenir els comentaris
    setState(() {
      comentaris = [
        Comentari(
          id: 1,
          idMissatge: widget.missatge.id,
          text: "Interessant punt de vista!",
          dataHora: DateTime.now(),
          likes: 5,
          dislikes: 1,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detall del Missatge"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.missatge.text, style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comentaris.length,
              itemBuilder: (context, index) {
                final comentari = comentaris[index];
                return ListTile(
                  title: Text(comentari.text),
                  subtitle: Text("${comentari.likes} Likes - ${comentari.dislikes} Dislikes"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
