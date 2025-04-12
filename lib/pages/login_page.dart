import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';  // Page d'accueil ou page suivante après la connexion

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour les champs de texte
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instance de FirebaseAuth pour gérer l'authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fonction pour connecter l'utilisateur avec son email et mot de passe
  Future<void> signInWithEmailPassword() async {
    try {
      // Tentative de connexion avec les identifiants fournis par l'utilisateur
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Affichage dans la console si la connexion réussie
      print('Utilisateur connecté : ${userCredential.user}');

      // Affichage d'un message de succès avec un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie !')),
      );

      // Redirection vers la page d'accueil (ou une autre page) après la connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),  // Accès à la page WelcomePage
      );

    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs d'authentification Firebase
      String errorMessage = '';

      // Cas où l'utilisateur n'existe pas dans Firebase
      if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé avec cet email.';
      }
      // Cas où le mot de passe est incorrect
      else if (e.code == 'wrong-password') {
        errorMessage = 'Mot de passe incorrect.';
      }
      // Cas pour toutes les autres erreurs Firebase
      else {
        errorMessage = 'Erreur inconnue : ${e.message}';
      }

      // Affichage du message d'erreur avec un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Gestion des erreurs générales (en dehors de Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue, veuillez réessayer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),  // Titre de la barre d'app
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Espacement autour du formulaire
        child: Column(
          children: [
            // Champ pour entrer l'email
            TextField(
              controller: _emailController,  // Contrôleur lié au champ email
              decoration: InputDecoration(labelText: 'Email'),  // Label affiché pour le champ
              keyboardType: TextInputType.emailAddress,  // Clavier adapté pour l'email
            ),

            // Champ pour entrer le mot de passe
            TextField(
              controller: _passwordController,  // Contrôleur lié au champ mot de passe
              obscureText: true,  // Masquer les caractères du mot de passe
              decoration: InputDecoration(labelText: 'Mot de passe'),  // Label affiché pour le mot de passe
            ),

            SizedBox(height: 20),  // Espacement entre les éléments

            // Bouton pour tenter la connexion
            ElevatedButton(
              onPressed: signInWithEmailPassword,  // Appel de la fonction de connexion
              child: Text('Se connecter'),  // Texte du bouton
            ),
          ],
        ),
      ),
    );
  }
}
