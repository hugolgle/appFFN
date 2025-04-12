import 'package:flutter/material.dart';
import './exercices/pushUp.dart';  // Importation de la page des pompes

class ExercisesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercices"),  // Titre de la page "Exercices"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Espacement autour de la grille
        child: GridView.count(
          crossAxisCount: 2, // Nombre de colonnes dans la grille
          crossAxisSpacing: 16, // Espacement entre les colonnes
          mainAxisSpacing: 16, // Espacement entre les lignes
          children: [
            // Bouton Pompes
            ExerciseButton(
              exerciseName: "Pompes",  // Nom de l'exercice
              onPressed: () {
                // Action pour naviguer vers la page des Pompes
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PompesPage()),  // Navigation vers la page des Pompes
                );
              },
            ),
            // Bouton Squats
            ExerciseButton(
              exerciseName: "Squats",  // Nom de l'exercice
              onPressed: () {
                // Action pour les squats (à définir)
              },
            ),
            // Autre exercice : Tractions
            ExerciseButton(
              exerciseName: "Tractions",  // Nom de l'exercice
              onPressed: () {
                // Action pour les tractions (à définir)
              },
            ),
            // Autre exercice : Gainage
            ExerciseButton(
              exerciseName: "Gainage",  // Nom de l'exercice
              onPressed: () {
                // Action pour le gainage (à définir)
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseButton extends StatelessWidget {
  final String exerciseName;  // Nom de l'exercice affiché sur le bouton
  final VoidCallback onPressed;  // Callback qui sera exécuté lorsqu'on appuie sur le bouton

  ExerciseButton({required this.exerciseName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,  // Déclenche la fonction onPressed passée en paramètre
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),  // Coins arrondis pour le bouton
        ),
        padding: EdgeInsets.all(20),  // Taille du bouton
      ),
      child: Text(
        exerciseName,  // Texte affiché sur le bouton (nom de l'exercice)
        style: TextStyle(
          fontSize: 18,  // Taille du texte
          fontWeight: FontWeight.bold,  // Gras pour le texte
        ),
      ),
    );
  }
}
