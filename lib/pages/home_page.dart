import 'package:flutter/material.dart';
import './exercices/pushUp.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Deux colonnes
          crossAxisSpacing: 16, // Espacement entre les colonnes
          mainAxisSpacing: 16, // Espacement entre les lignes
          children: [
            // Bouton Pompes
            ExerciseButton(
              exerciseName: "Pompes",
              onPressed: () {
                // Naviguer vers la page des pompes
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PompesPage()),
                );
              },

            ),
            // Bouton Squats
            ExerciseButton(
              exerciseName: "Squats",
              onPressed: () {
                // Action pour les squats
              },
            ),
            // Autre exercice : Tractions
            ExerciseButton(
              exerciseName: "Tractions",
              onPressed: () {
                // Action pour les tractions
              },
            ),
            // Autre exercice : Gainage
            ExerciseButton(
              exerciseName: "Gainage",
              onPressed: () {
                // Action pour le gainage
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseButton extends StatelessWidget {
  final String exerciseName;
  final VoidCallback onPressed;

  ExerciseButton({required this.exerciseName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Couleur de fond
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Coins arrondis
        ),
        padding: EdgeInsets.all(20), // Taille du bouton
      ),
      child: Text(
        exerciseName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
