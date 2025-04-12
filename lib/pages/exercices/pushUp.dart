import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';  // Pour accéder aux capteurs du téléphone
import 'package:http/http.dart' as http;  // Pour effectuer la requête HTTP

class PompesPage extends StatefulWidget {
  @override
  _PompesPageState createState() => _PompesPageState();
}

class _PompesPageState extends State<PompesPage> {
  int _count = 0;  // Compteur de pompes
  bool _isRunning = false;  // Indicateur pour savoir si l'exercice est en cours
  late Timer _timer;  // Minuteur
  int _remainingTime = 30;  // Temps restant en secondes pour l'exercice
  double _previousY = 0.0;  // Valeur précédente de l'axe Y pour détecter les mouvements
  bool _isDescending = false;  // Indicateur si l'utilisateur descend
  bool _isAscending = false;  // Indicateur si l'utilisateur remonte
  bool _isExerciseCompleted = false; // Nouvel indicateur pour savoir si l'exercice est terminé

  @override
  void initState() {
    super.initState();
    _startAccelerometerListening();
  }

  // Fonction pour envoyer les données au backend
  Future<void> _sendDataToBackend() async {
    try {
      final response = await http.post(
        Uri.parse('https://run.mocky.io/v3/138727c3-cff2-475f-8671-535b4d2412ab'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nombre_de_pompes': _count,  // Nombre de pompes effectuées
          'temps_restant': _remainingTime,  // Temps restant à la fin de l'exercice
        }),
      );

      if (response.statusCode == 200) {
        print('Données envoyées avec succès');
      } else {
        print('Erreur lors de l\'envoi des données: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Écoute de l'accéléromètre pour détecter les pompes
  void _startAccelerometerListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_isRunning) {
        // Phase descendante : l'utilisateur descend si Y dépasse un seuil
        if (event.y > 1.0 && !_isDescending) {
          _isDescending = true;  // L'utilisateur commence à descendre
        }

        // Phase ascendante : l'utilisateur remonte si Y passe en dessous d'un seuil
        if (event.y < 0.2 && _isDescending) {
          _isAscending = true;  // L'utilisateur commence à remonter
        }

        // Validation de la pompe uniquement quand l'utilisateur revient vers le haut
        if (_isAscending && event.y > 1.0) {
          setState(() {
            _count++;  // Incrémente le nombre de pompes
          });
          _isDescending = false;  // Attendre le prochain mouvement descendant
          _isAscending = false;  // Réinitialiser la phase ascendante
        }
      }
    });
  }

  // Fonction pour démarrer le chronomètre et l'exercice
  void _startExercise() {
    setState(() {
      _isRunning = true;
      _count = 0;  // Réinitialiser le compteur de pompes
      _remainingTime = 30;  // Réinitialiser le chronomètre à 30 secondes
      _isExerciseCompleted = false; // Réinitialiser l'état de l'exercice
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _isExerciseCompleted = true;  // Marquer l'exercice comme terminé
        });

        // Appeler la fonction pour envoyer les données au backend après la fin de l'exercice
        _sendDataToBackend();
      }
    });
  }


  // Fonction pour réinitialiser l'exercice
  void _resetExercise() {
    setState(() {
      _isRunning = false;
      _count = 0;
      _remainingTime = 30;
      _isExerciseCompleted = false;  // Réinitialiser l'état de l'exercice
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();  // Annuler le timer si la page est fermée
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pompes"),
        centerTitle: true, // Centrer le titre
      ),
      body: Center(  // Centrer tout le contenu
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centrer les éléments dans la colonne
            crossAxisAlignment: CrossAxisAlignment.center,  // Centrer horizontalement
            children: [
              // Affichage du nombre de pompes
              Text(
                "Nombre de pompes: $_count",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Affichage du temps restant
              Text(
                "Temps restant: $_remainingTime s",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 40),
              // Bouton pour démarrer l'exercice
              ElevatedButton(
                onPressed: _isRunning ? null : _startExercise,
                child: Text("Démarrer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Utilisation de backgroundColor au lieu de primary
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              // Bouton pour réinitialiser l'exercice
              ElevatedButton(
                onPressed: _isExerciseCompleted ? _resetExercise : null,
                child: Text("Réinitialiser"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Utilisation de backgroundColor au lieu de primary
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
