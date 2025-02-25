import 'package:flutter/material.dart';
import 'package:social_app/screens/home_page.dart';
import '../models/missatge.dart';
import '../providers/api_provider.dart';

class MissatgeItem extends StatelessWidget {
  final Missatge missatge;
  final VoidCallback onTap;
  final Future<void> onLikeDislike;

  const MissatgeItem({
    Key? key, 
    required this.missatge, 
    required this.onTap, 
    required this.onLikeDislike
  }) : super(key: key);

  Future<void> _likeMissatge() async {
    try {
      await ApiProvider().likeMissatge(missatge.id);
      await onLikeDislike;
    } catch (e) {
      print("Error fent like: $e");
    }
  }

  Future<void> _dislikeMissatge() async {
    try {
      await ApiProvider().dislikeMissatge(missatge.id);
      await onLikeDislike;
    } catch (e) {
      print("Error fent dislike: $e");
    }
  }

  String _calcData() {
    try {
      final currentTime = DateTime.now();
      final missatgeTime = missatge.dataHora; // Assegura't que `missatge.dataHora` sigui de tipus DateTime
      final difference = currentTime.difference(missatgeTime).inHours;

      if (difference < 24) {
        return 'Fa $difference hores';
      } else {
        return '${missatge.dataHora}';
      }
    } catch (e) {
      print("Error calculant la data: $e");
      return 'Error'; // Retornem un missatge d'error en cas que s'executi el catch
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(_calcData(), style: TextStyle(fontSize: 13),),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(missatge.text, style: TextStyle(fontSize: 20),),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alinea els likes i dislikes a la dreta
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.green),
                  onPressed: _likeMissatge,
                ),
                Text("${missatge.likes} - ${missatge.dislikes}"),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: Colors.red),
                  onPressed: _dislikeMissatge,
                ),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }
}
