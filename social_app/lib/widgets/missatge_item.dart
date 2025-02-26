import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/missatge.dart';
import '../providers/api_provider.dart';

class MissatgeItem extends StatelessWidget {
  final Missatge missatge;
  final VoidCallback onTap;
  final Future<void> onLikeDislike;
  final Position? posicioActual; // Afegim la posició actual de l'usuari

  const MissatgeItem({
    Key? key, 
    required this.missatge, 
    required this.onTap, 
    required this.onLikeDislike,
    this.posicioActual, // Paràmetre opcional
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
      final missatgeTime = missatge.dataHora;
      final difference = currentTime.difference(missatgeTime).inHours;
      final diffMinuts = currentTime.difference(missatgeTime).inMinutes;

      if (diffMinuts < 60) return 'Fa $diffMinuts minuts';
      if (difference < 24) return 'Fa $difference hores';
      return '${missatgeTime.day}/${missatgeTime.month}/${missatgeTime.year}';
    } catch (e) {
      print("Error calculant la data: $e");
      return 'Error';
    }
  }

  String _calcDistancia() {
    if (posicioActual == null) return 'Ubicació no disponible';

    double distancia = _calcularDistancia(
      posicioActual!.latitude,
      posicioActual!.longitude,
      missatge.latitud,
      missatge.longitud,
    );

    if (distancia < 1000) {
      return '${distancia.toStringAsFixed(0)} m';
    } else {
      return '${(distancia / 1000).toStringAsFixed(1)} km';
    }
  }

  // Funció per calcular la distància entre dues coordenades en metres
  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const double radioTerra = 6371000; // en metres
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radioTerra * c; // Retorna la distància en metres
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _calcData(), 
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  _calcDistancia(), 
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(missatge.text, style: TextStyle(fontSize: 20),),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
