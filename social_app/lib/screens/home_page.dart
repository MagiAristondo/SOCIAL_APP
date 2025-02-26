import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    bool permisos = await _demanarPermisos();
    if (!permisos) {
      setState(() {
        _errorMessage = "Els permisos de localització són necessaris per veure missatges propers.";
        _isLoading = false;
      });
      return;
    }
    
    try {
    // Obtenir la ubicació actual de l'usuari
    Position posicioActual = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    List<Missatge> response = await ApiProvider().getMissatges();

    // Filtrar els missatges dins d'un radi de 100 metres
    List<Missatge> missatgesFiltrats = response.where((missatge) {
      double distancia = _calcularDistancia(
        posicioActual.latitude,
        posicioActual.longitude,
        missatge.latitud,
        missatge.longitud,
      );
      return distancia <= 100.0; // Només missatges dins de 100m
    }).toList();

    setState(() {
      missatges = missatgesFiltrats;
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

Future<bool> _demanarPermisos() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false; // Permís denegat
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false; // Permís denegat permanentment
  }
  return true; // Permís concedit
}

// Funció per calcular la distància entre dues coordenades en metres
double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
  const double radioTerra = 6371000; // en metres
  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);

  double a = 
      (sin(dLat / 2) * sin(dLat / 2)) +
      cos(lat1 * (pi / 180)) *
      cos(lat2 * (pi / 180)) *
      (sin(dLon / 2) * sin(dLon / 2));

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radioTerra * c; // Retorna la distància en metres
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
