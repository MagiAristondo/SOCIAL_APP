class Missatge {
  final int id;
  final String text;
  final DateTime dataHora;
  final int likes;
  final int dislikes;
  final double latitud;
  final double longitud;

  Missatge({
    required this.id,
    required this.text,
    required this.dataHora,
    required this.likes,
    required this.dislikes,
    required this.latitud,
    required this.longitud,
  });

  // Convertir un JSON en un objecte Missatge
  factory Missatge.fromJson(Map<String, dynamic> json) {
    return Missatge(
      id: json['id'],
      text: json['text'],
      dataHora: DateTime.parse(json['data_hora']),
      likes: json['likes'],
      dislikes: json['dislikes'],
      latitud: (json['latitud'] is double) ? json['latitud'] : double.parse(json['latitud'].toString()),
      longitud: (json['longitud'] is double) ? json['longitud'] : double.parse(json['longitud'].toString()),
    );
  }

  // Convertir un objecte Missatge a JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'text': text,
  //     'data_hora': dataHora.toIso8601String(),
  //     'likes': likes,
  //     'dislikes': dislikes,
  //     'latitud': latitud,
  //     'longitud': longitud,
  //   };
  // }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'latitud': latitud ?? 0.0,
      'longitud': longitud ?? 0.0,
    };
  }
}
