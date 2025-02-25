import 'package:flutter/material.dart';
import '../models/missatge.dart';
import '../models/comentari.dart';
import '../providers/api_provider.dart';
import '../widgets/comment_list.dart';
import '../widgets/comment_input.dart';

class MessageDetailPage extends StatefulWidget {
  final Missatge missatge;

  const MessageDetailPage({Key? key, required this.missatge}) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final ApiProvider _apiProvider = ApiProvider();
  List<Comentari> comentaris = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarComentaris();
  }

  Future<void> _carregarComentaris() async {
    try {
      final comentarisObtinguts = await _apiProvider.getComentaris(widget.missatge.id);
      setState(() {
        comentaris = comentarisObtinguts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error en carregar els comentaris";
        _isLoading = false;
      });
    }
  }

  Future<void> _afegirComentari(Comentari nouComentari) async {
    setState(() {
      comentaris.insert(0, nouComentari); // Afegim a la llista localment
    });
    _carregarComentaris(); // Recàrrega des de la API per mantenir consistència
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detall del Missatge"),
        backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity, // Amplada completa
            color: Color.fromARGB(255, 224, 224, 224), // Fons gris clar per tota la secció
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.missatge.text,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: CommentList(
              comentaris: comentaris,
              isLoading: _isLoading,
              errorMessage: _errorMessage,
            ),
          ),
          CommentInput(
            missatgeId: widget.missatge.id,
            onCommentAdded: _afegirComentari,
          ),
        ],
      ),
    );
  }
}
