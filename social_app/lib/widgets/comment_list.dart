import 'package:flutter/material.dart';
import '../models/comentari.dart';

class CommentList extends StatelessWidget {
  final List<Comentari> comentaris;
  final bool isLoading;
  final String? errorMessage;

  const CommentList({
    Key? key,
    required this.comentaris,
    required this.isLoading,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    return ListView.builder(
      itemCount: comentaris.length,
      itemBuilder: (context, index) {
        final comentari = comentaris[index];
        return Column(
          children: [
            ListTile(
              title: Text(comentari.text),
              subtitle: Text("${comentari.likes} Likes - ${comentari.dislikes} Dislikes"),
            ),
            Divider(thickness: 1, color: Color.fromARGB(255, 224, 224, 224)),
          ],
        );
      },
    );
  }
}
