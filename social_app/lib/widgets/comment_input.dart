import 'package:flutter/material.dart';
import '../models/comentari.dart';
import '../providers/api_provider.dart';

class CommentInput extends StatefulWidget {
  final int missatgeId;
  final Function(Comentari) onCommentAdded;

  const CommentInput({
    Key? key,
    required this.missatgeId,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _comentariController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();
  bool _isSending = false;

  Future<void> _publicarComentari() async {
    if (_comentariController.text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final nouComentari = Comentari(
      id: 0, // L'API assignarà l'ID
      idMissatge: widget.missatgeId,
      text: _comentariController.text,
      dataHora: DateTime.now(),
      likes: 0,
      dislikes: 0,
    );

    try {
      final success = await _apiProvider.createComentari(nouComentari);
      if (success) {
        _comentariController.clear();
        widget.onCommentAdded(nouComentari);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en publicar el comentari")),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _comentariController,
              decoration: InputDecoration(
                hintText: "Escriu un comentari...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          _isSending
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _publicarComentari,
                ),
        ],
      ),
    );
  }
}
