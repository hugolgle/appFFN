import 'package:appffn/main.dart';
import 'package:appffn/pages/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Contrôleurs pour récupérer les valeurs saisies dans les champs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instance de notre service d'authentification
  final AuthService _authService = AuthService();

  // Fonction qui gère l'inscription de l'utilisateur
  Future<void> signUpWithEmailPassword() async {
    try {
      // Tentative de création d'un nouvel utilisateur
      final user = await _authService.signUp(
        _emailController.text,
        _passwordController.text,
      );
      // Si l'utilisateur a été créé avec succès
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie !')),
        );
        // Redirige vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques à Firebase Auth
      String errorMessage = '';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Cet email est déjà utilisé.';
      } else {
        errorMessage = 'Erreur : ${e.message}';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Gestion des erreurs non prévues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue, veuillez réessayer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'applications avec le titre de la page
      appBar: AppBar(title: Text("S'inscrire")),
      // Contenu de la page dans un Padding pour un meilleur espacement
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de saisie de l'email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Champ de saisie du mot de passe
            TextField(
              controller: _passwordController,
              obscureText: true, // Masque la saisie pour le mot de passe
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            SizedBox(height: 20), // Espace vertical entre les éléments
            // Bouton pour valider l'inscription
            ElevatedButton(
              onPressed: signUpWithEmailPassword,
              child: Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
