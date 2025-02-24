class Comentari {
  final int id;
  final int idMissatge;
  final String text;
  final DateTime dataHora;
  final int likes;
  final int dislikes;

  Comentari({
    required this.id,
    required this.idMissatge,
    required this.text,
    required this.dataHora,
    required this.likes,
    required this.dislikes,
  });

  // Convertir un JSON en un objecte Comentari
  factory Comentari.fromJson(Map<String, dynamic> json) {
    return Comentari(
      id: json['id'],
      idMissatge: json['id_missatge'],
      text: json['text'],
      dataHora: DateTime.parse(json['data_hora']),
      likes: json['likes'],
      dislikes: json['dislikes'],
    );
  }

  // Convertir un objecte Comentari a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_missatge': idMissatge,
      'text': text,
      'data_hora': dataHora.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
