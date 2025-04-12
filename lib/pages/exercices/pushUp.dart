import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';  // Pour accéder aux capteurs du téléphone
import 'package:http/http.dart' as http;  // Pour effectuer la requête HTTP
import 'package:shared_preferences/shared_preferences.dart';  // Pour stocker les données localement

class PompesPage extends StatefulWidget {
  @override
  _PompesPageState createState() => _PompesPageState();
}

class _PompesPageState extends State<PompesPage> with TickerProviderStateMixin {
  int _count = 0;  // Compteur de pompes effectuées
  bool _isRunning = false;  // Indicateur si l'exercice est en cours
  late Timer _timer;  // Minuteur pour suivre le temps de l'exercice
  int _remainingTime = 30;  // Temps restant en secondes pour l'exercice
  double _previousY = 0.0;  // Valeur précédente de l'axe Y pour détecter les mouvements
  bool _isDescending = false;  // Si l'utilisateur descend (phase descendante)
  bool _isAscending = false;  // Si l'utilisateur remonte (phase ascendante)
  bool _isExerciseCompleted = false;  // Indicateur de fin d'exercice

  late AnimationController _countAnimationController;
  late AnimationController _timeAnimationController;

  @override
  void initState() {
    super.initState();
    _startSensorListening();  // Démarre l'écoute des capteurs (accéléromètre et gyroscope)
    _loadSavedData();  // Charge les données sauvegardées à l'initialisation

    // Initialisation des contrôleurs d'animation pour animer les valeurs de compte et de temps
    _countAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _timeAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
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
        _clearSavedData(); // Effacer les données locales après un envoi réussi
      } else {
        print('Erreur lors de l\'envoi des données: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Sauvegarder les données localement (nombre de pompes et temps restant)
  Future<void> _saveDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('count', _count);
    await prefs.setInt('remainingTime', _remainingTime);
  }

  // Charger les données sauvegardées depuis SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('count') ?? 0;  // Charger le nombre de pompes
      _remainingTime = prefs.getInt('remainingTime') ?? 30;  // Charger le temps restant
    });
  }

  // Effacer les données locales après envoi au backend
  Future<void> _clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('count');
    await prefs.remove('remainingTime');
  }

  // Écoute des capteurs (accéléromètre et gyroscope) pour détecter les pompes effectuées
  void _startSensorListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_isRunning) {
        // Détection de la phase descendante : l'utilisateur descend si Y dépasse un seuil
        if (event.y > 1.0 && !_isDescending) {
          _isDescending = true;  // L'utilisateur commence à descendre
        }

        // Détection de la phase ascendante : l'utilisateur remonte si Y est inférieur à un seuil
        if (event.y < 0.2 && _isDescending) {
          _isAscending = true;  // L'utilisateur commence à remonter
        }

        // Validation de la pompe : l'utilisateur valide une pompe lorsque Y est à nouveau au-dessus du seuil
        if (_isAscending && event.y > 1.0) {
          setState(() {
            _count++;  // Incrémenter le nombre de pompes
          });
          _isDescending = false;  // Attendre le prochain mouvement descendant
          _isAscending = false;  // Réinitialiser l'ascension
        }
      }
    });

    // Écoute du gyroscope pour suivre les rotations de l'utilisateur pendant les pompes
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (_isRunning) {
        // Vous pouvez utiliser la vitesse angulaire pour détecter des mouvements spécifiques
        // comme la rotation du corps lors des pompes
        if (event.z.abs() > 2.0) {  // Exemple d'une valeur seuil pour détecter un mouvement
          setState(() {
            _count++;  // Incrémenter le nombre de pompes si un mouvement significatif est détecté
          });
        }
      }
    });
  }

  // Fonction pour démarrer l'exercice et le chronomètre
  void _startExercise() {
    setState(() {
      _isRunning = true;
      _count = 0;  // Réinitialiser le compteur de pompes
      _remainingTime = 30;  // Réinitialiser le chronomètre à 30 secondes
      _isExerciseCompleted = false;  // Réinitialiser l'état de l'exercice
    });

    // Minuteur pour décrémenter le temps restant chaque seconde
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

        // Sauvegarder les données localement avant l'envoi au backend
        _saveDataLocally();

        // Envoi des données au backend après la fin de l'exercice
        _sendDataToBackend();
      }
    });

    // Démarrer les animations d'affichage du compteur et du temps restant
    _countAnimationController.forward(from: 0.0);
    _timeAnimationController.forward(from: 0.0);
  }

  // Fonction pour réinitialiser l'exercice
  void _resetExercise() {
    setState(() {
      _isRunning = false;
      _count = 0;
      _remainingTime = 30;
      _isExerciseCompleted = false;  // Réinitialiser l'état de l'exercice
    });
    _clearSavedData();  // Effacer les données locales lors de la réinitialisation

    // Réinitialiser les animations
    _countAnimationController.reverse(from: 1.0);
    _timeAnimationController.reverse(from: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();  // Annuler le timer si la page est fermée
    _countAnimationController.dispose();  // Libérer les ressources de l'animation
    _timeAnimationController.dispose();  // Libérer les ressources de l'animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pompes"),
        centerTitle: true,  // Centrer le titre dans la barre d'applications
      ),
      body: Center(  // Centrer le contenu dans la page
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centrer verticalement les éléments
            crossAxisAlignment: CrossAxisAlignment.center,  // Centrer horizontalement les éléments
            children: [
              // Animation du nombre de pompes effectuées
              FadeTransition(
                opacity: _countAnimationController,
                child: ScaleTransition(
                  scale: _countAnimationController,
                  child: Text(
                    "Nombre de pompes: $_count",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Animation du temps restant
              FadeTransition(
                opacity: _timeAnimationController,
                child: ScaleTransition(
                  scale: _timeAnimationController,
                  child: Text(
                    "Temps restant: $_remainingTime s",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Bouton pour démarrer l'exercice
              ElevatedButton(
                onPressed: _isRunning ? null : _startExercise,
                child: Text("Démarrer"),
                style: ElevatedButton.styleFrom(
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
