import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/missatge.dart';
import '../models/comentari.dart';

class ApiProvider {
  final String baseUrl = "http://10.0.2.2:3000/api";

  Future<List<Missatge>> getMissatges() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Missatge.fromJson(json)).toList();
    } else {
      throw Exception("Error en carregar els missatges");
    }
  }

  Future<bool> createMissatge(Missatge missatge) async {
    final jsonBody = jsonEncode(missatge.toJson());
    print("JSON enviat: $jsonBody");

    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
    );

    print("Resposta del servidor: ${response.statusCode}");
    print("Cos de la resposta: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error en crear el missatge: ${response.body}");
    }
  }

  Future<List<Comentari>> getComentaris(int missatgeId) async {
    final response = await http.get(Uri.parse('$baseUrl/comentaris/$missatgeId'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Comentari.fromJson(json)).toList();
    } else {
      throw Exception("Error en carregar els comentaris");
    }
  }

  Future<bool> createComentari(Comentari comentari) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comentaris'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(comentari.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error en crear el comentari");
    }
  }
}
